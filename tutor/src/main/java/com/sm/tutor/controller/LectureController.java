package com.sm.tutor.controller;

import com.sm.tutor.domain.Lecture;
import com.sm.tutor.domain.dto.LectureDto;
import com.sm.tutor.service.LectureService;
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

  @GetMapping
  public List<LectureDto> getAllLectures() {
    return lectureService.getAllLecturesWithDetails();
  }

  @PostMapping
  public LectureDto createLecture(@RequestBody Lecture lecture) {
    return lectureService.createLecture(lecture);
  }

  /*@PutMapping("/{id}")
  public Lecture updateLecture(@PathVariable Integer id, @RequestBody Lecture lecture) {
    return lectureService.updateLecture(id, lecture);
  }*/

  @DeleteMapping("/{id}")
  public void deleteLecture(@PathVariable Long id) {
    lectureService.deleteLecture(id);
  }

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
