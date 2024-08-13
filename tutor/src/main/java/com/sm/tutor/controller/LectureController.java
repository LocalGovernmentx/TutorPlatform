package com.sm.tutor.controller;

import com.sm.tutor.domain.dto.LectureDto;
import com.sm.tutor.service.LectureService;
import com.sm.tutor.service.LocationService;
import com.sm.tutor.service.MemberService;
import io.swagger.v3.oas.annotations.Operation;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/lectures")
public class LectureController {

  @Autowired
  private LectureService lectureService;

  @Autowired
  private MemberService memberService;

  @Autowired
  private LocationService locationService;


  @Operation(summary = "강의 목록 조회")
  @GetMapping
  public List<LectureDto> getAllLectures() {
    return lectureService.getAllLecturesWithDetails();
  }

  @Operation(summary = "강의 생성")
  @PostMapping
  public LectureDto createLecture(@RequestBody LectureDto lectureDto) {
    return lectureService.createLecture(lectureDto);
  }

  /*@Operation(summary = "강의 수정")
  @PutMapping("/{id}")
  public Lecture updateLecture(@PathVariable Integer id, @RequestBody Lecture lecture) {
    return lectureService.updateLecture(id, lecture);
  }*/

  @Operation(summary = "강의 삭제")
  @DeleteMapping("/{id}")
  public void deleteLecture(@PathVariable Long id) {
    lectureService.deleteLectureByid(id);
  }

  @Operation(summary = "선택한 강의 조회")
  @GetMapping("/{id}")
  public ResponseEntity<LectureDto> getLectureById(@PathVariable Long id) {
    LectureDto lecture = lectureService.getLectureById(id);
    if (lecture != null) {
      return new ResponseEntity<>(lecture, HttpStatus.OK);
    } else {
      return new ResponseEntity<>(HttpStatus.OK);
    }
  }
}
