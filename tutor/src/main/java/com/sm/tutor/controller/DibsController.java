package com.sm.tutor.controller;

import com.sm.tutor.service.DibsService;
import com.sm.tutor.service.LectureService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/api/dibs")
public class DibsController {

  @Autowired
  private DibsService dibsService;
  @Autowired
  private LectureService lectureService;

  @Operation(
      summary = "찜한 강의 추가",
      description = "특정 강의를 찜 목록에 추가합니다. 요청 헤더에서 사용자 이메일을 추출하여 해당 사용자에 대해 강의를 찜 목록에 추가합니다.",
      responses = {
          @ApiResponse(responseCode = "200", description = "강의가 찜 목록에 성공적으로 추가됨"),
          @ApiResponse(responseCode = "400", description = "잘못된 요청 또는 이미 찜 목록에 있는 강의")
      }
  )
  @PostMapping("/{lectureId}")
  public ResponseEntity<Void> addDibs(@PathVariable Integer lectureId, HttpServletRequest request) {
    String email = (String) request.getAttribute("userEmail");
    dibsService.addDibs(lectureId, email);
    return new ResponseEntity<>(HttpStatus.OK);
  }


  @Operation(
      summary = "찜한 강의 제거",
      description = "특정 강의를 찜 목록에서 제거합니다. 요청 헤더에서 사용자 이메일을 추출하여 해당 사용자에 대해 강의를 찜 목록에서 제거합니다.",
      responses = {
          @ApiResponse(responseCode = "200", description = "강의가 찜 목록에서 성공적으로 제거됨"),
          @ApiResponse(responseCode = "400", description = "잘못된 요청 또는 찜 목록에 없는 강의")
      }
  )
  @DeleteMapping("/{lectureId}")
  public ResponseEntity<Void> removeDibs(@PathVariable Integer lectureId,
      HttpServletRequest request) {
    String email = (String) request.getAttribute("userEmail");
    dibsService.removeDibs(lectureId, email);
    return new ResponseEntity<>(HttpStatus.OK);
  }

//  @Operation(
//      summary = "찜한 강의 조회",
//      description = "사용자가 찜한 강의의 정보를 조회합니다. 요청 헤더에서 사용자 이메일을 추출하여 해당 사용자가 찜한 강의의 상세 정보를 반환합니다.",
//      responses = {
//          @ApiResponse(responseCode = "200", description = "찜한 강의의 상세 정보 반환"),
//          @ApiResponse(responseCode = "404", description = "사용자가 찜한 강의가 없음")
//      }
//  )
//  @GetMapping()
//  public ResponseEntity<List<LectureSmallView>> getDibsLectureDetails(HttpServletRequest request) {
//    String email = (String) request.getAttribute("userEmail");
//    List<LectureSmallView> lectureDetails = dibsService.getDibsLectureDetails(email);
//    return new ResponseEntity<>(lectureDetails, HttpStatus.OK);
//  }


}

