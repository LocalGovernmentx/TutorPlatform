package com.sm.tutor.controller;

import com.sm.tutor.domain.Lecture;
import com.sm.tutor.domain.Member;
import com.sm.tutor.domain.dto.LectureCreateDto;
import com.sm.tutor.domain.dto.LectureDto;
import com.sm.tutor.domain.dto.SimpleLectureResponseDto;
import com.sm.tutor.service.ImageService;
import com.sm.tutor.service.LectureService;
import com.sm.tutor.service.LocationService;
import com.sm.tutor.service.MemberService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@RestController
@RequestMapping("/api/lectures")
public class LectureController {

  @Autowired
  ImageService imageService;
  @Autowired
  private LectureService lectureService;
  @Autowired
  private MemberService memberService;

  @Autowired
  private LocationService locationService;


  @Operation(summary = "강의 목록 조회")
  @GetMapping
  public ResponseEntity<List<LectureDto>> getAllLectures(HttpServletRequest request) {
    String email = (String) request.getAttribute("userEmail");

    return new ResponseEntity<>(lectureService.getAllLecturesWithDetails(), HttpStatus.OK);
  }

  @Operation(summary = "강의 생성")
  @PostMapping(consumes = {MediaType.MULTIPART_FORM_DATA_VALUE, MediaType.APPLICATION_JSON_VALUE})
  public ResponseEntity<?> createLecture(
      @RequestPart("lectureCreateDto") LectureCreateDto lectureCreateDto,
      @RequestParam List<MultipartFile> files,
      HttpServletRequest request) throws IOException {
    String email = (String) request.getAttribute("userEmail");
    Member member = memberService.getMemberByEmail(email);
    if (member.getType() != 2) {
      return new ResponseEntity<>(Collections.singletonMap("message", "is not tutor"),
          HttpStatus.UNAUTHORIZED);
    }
//    LectureCreateDto lectureCreateDto = new LectureCreateDto(categoryId, title, content, activation,
//        online, tuitionMaximum, tuitionMinimum, tuteeNumber, gender, level, ages, locations,
//        new ArrayList<>(), times);
    LectureDto lectureDtoResult = lectureService.createLecture(email, lectureCreateDto);
    Optional<Lecture> lecture = lectureService.getLectureById(
        Long.valueOf(lectureDtoResult.getId()));
    // 파일들을 S3에 업로드
    System.out.println(lecture.get().getId());
    for (MultipartFile file : files) {
      String result = imageService.uploadImage(String.valueOf(lecture.get().getId()), "lecture",
          file);
      if (!result.equals("Lecture image uploaded successfully")) {
        return new ResponseEntity<>(Collections.singletonMap("message", result),
            HttpStatus.INTERNAL_SERVER_ERROR);
      }
    }
    return new ResponseEntity<>(Collections.singletonMap("message", "Lecture created successfully"),
        HttpStatus.CREATED);
  }

  /*@Operation(summary = "강의 수정")
  @PutMapping("/{id}")
  public Lecture updateLecture(@PathVariable Integer id, @RequestBody Lecture lecture) {
    return lectureService.updateLecture(id, lecture);
  }*/

  @Operation(summary = "강의 삭제")
  @DeleteMapping("/{id}")
  public ResponseEntity<?> deleteLecture(@PathVariable Long id) {
    boolean status = lectureService.deleteLectureById(id);
    if (status) {
      return new ResponseEntity<>(
          Collections.singletonMap("message", "Lecture deleted successfully"), HttpStatus.OK);
    } else {
      return new ResponseEntity<>(Collections.singletonMap("message", "Lecture not found"),
          HttpStatus.NOT_FOUND);
    }
  }

  @Operation(summary = "선택한 강의 조회")
  @GetMapping("/{id}")
  public ResponseEntity<?> getLectureById(@PathVariable Long id) {
    LectureDto lecture = lectureService.getLectureDtoById(id);
    if (lecture != null) {
      return new ResponseEntity<>(lecture, HttpStatus.OK);
    } else {
      return new ResponseEntity<>(Collections.singletonMap("message", "Lecture not found"),
          HttpStatus.NOT_FOUND);
    }
  }

  @Operation(summary = "강의 페이징",
      description = """
          page: 현재 페이지 위치 (처음 위치: 0)
                   \s
          size: page 당 entity 개수 (기본: 10)
                   \s
          sort: 정렬할 속성(오름차순) (기본: id)""")
  @GetMapping("/paging")
  public ResponseEntity<Page<LectureDto>> paging(
      @PageableDefault(page = 0, size = 10, sort = {"id"}) Pageable pageable) {
    Page<LectureDto> lectureDtoPages = lectureService.paging(pageable);

    return new ResponseEntity<>(lectureDtoPages, HttpStatus.OK);
  }

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: 성공", content = {
          @Content(schema = @Schema(implementation = Page.class))})
  })
  @Operation(summary = "필터링 + 강의 리스트",
      description = """ 
          paging에 대해서는 paging API와 동일
                   \s
          추가적으로 List<Integer> categoryId, Integer tuitionMaximum, List<Integer> locationId, Integer online, String keyword 을 받아서 이를 토대로 필터링 진행
                   \s
          강의 리스트에 대한 정보는 json에서 content에 list 형식으로 저장됩니다.
                   \s
          모든 파라미터는 required = false로, 파라미터 값을 반드시 보낼 필요는 없습니다. 파라미터가 없을 경우 NULL 처리됩니다.
                   \s
          성공하면 `200 OK` 상태 코드와 강의 리스트에 대한 정보를 반환합니다.
          """)
  @GetMapping("/list")
  public ResponseEntity<Page<SimpleLectureResponseDto>> getLectureByFilter(
      @PageableDefault(page = 0, size = 20, sort = {"id"}) Pageable pageable,
      @RequestParam(required = false) List<Integer> categoryId,
      @RequestParam(required = false) Integer tuitionMaximum,
      @RequestParam(required = false) List<Integer> locationId,
      @RequestParam(required = false) Integer online,
      @RequestParam(required = false) String keyword) {
    Page<SimpleLectureResponseDto> lectureDtoPages = lectureService.getLectureByFilter(pageable,
        categoryId, tuitionMaximum, locationId, online,
        keyword);

    return new ResponseEntity<>(lectureDtoPages, HttpStatus.OK);
  }

  @Operation(
      summary = "현재 사용자가 듣고 있는 강의 목록 조회",
      description = """
              현재 로그인된 사용자의 이메일을 기반으로 사용자가 듣고 있는 강의 목록을 조회합니다. \n
              요청 헤더에서 사용자 이메일을 추출하고, 해당 이메일에 대해 진행 중인 강의 목록을 반환합니다. \n
              이 API를 통해 사용자는 현재 듣고 있는 강의들을 확인할 수 있습니다. \n
              요청이 성공적으로 처리되면, `200 OK` 상태 코드와 함께 강의 목록을 반환합니다. \n
              요청이 실패하거나 강의 목록이 없는 경우에도 `200 OK` 상태 코드와 함께 빈 목록이 반환될 수 있습니다.
          """
  )
  @GetMapping("/ongoing")
  public ResponseEntity<List<LectureDto>> getOngoingLectures(HttpServletRequest request) {
    String email = (String) request.getAttribute("userEmail");
    List<LectureDto> ongoingLectures = lectureService.getOngoingLectures(email);
    return new ResponseEntity<>(ongoingLectures, HttpStatus.OK);
  }


  @Operation(summary = "강의 시작 (듣기)",
      description = "강의를 시작하고, 현재 사용자가 해당 강의를 듣기 시작합니다. 이미 듣고 있는 강의일 경우 400 에러가 발생합니다.")
  @PostMapping("/start/{id}")
  public ResponseEntity<LectureDto> startLecture(@PathVariable Long id,
      HttpServletRequest request) {
    String email = (String) request.getAttribute("userEmail");

    try {
      LectureDto lectureDto = lectureService.startLecture(id, email);
      return new ResponseEntity<>(lectureDto, HttpStatus.OK);
    } catch (IllegalArgumentException e) {
      // 에러 메시지와 함께 400 Bad Request 반환
      return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }
  }


}
