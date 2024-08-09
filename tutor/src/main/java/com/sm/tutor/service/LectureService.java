package com.sm.tutor.service;

import com.sm.tutor.converter.LectureConverter;
import com.sm.tutor.domain.Lecture;
import com.sm.tutor.domain.dto.LectureDto;
import com.sm.tutor.repository.LectureRepository;
import jakarta.persistence.EntityNotFoundException;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class LectureService {

  private final LectureRepository lectureRepository;

  private final LectureConverter lectureConverter;

  public List<LectureDto> getAllLecturesWithDetails() {
    return lectureRepository.findAll().stream().map(lectureConverter::toDto)
        .collect(
            Collectors.toList());
  }

  public LectureDto createLecture(Lecture lecture) {
    return lectureConverter.toDto(lectureRepository.save(lecture));
  }

  /*public Lecture updateLecture(Long id, Lecture updatedLecture) {
    Optional<Lecture> findLecture = lectureRepository.findById(id);
    if (findLecture.isPresent()) {

      updatedLecture.setId(id);
      return lectureRepository.save(updatedLecture);
    }
    throw new EntityNotFoundException("Lecture not found with id " + id);
  }*/

  public void deleteLecture(Long id) {
    if (lectureRepository.existsById(id)) {
      lectureRepository.deleteById(id);
    } else {
      throw new EntityNotFoundException("Lecture not found with id " + id);
    }
  }

  public LectureDto getLectureById(Long id) {
    Optional<Lecture> lecture = lectureRepository.findById(id);
    return lecture.map(lectureConverter::toDto).orElse(null);
  }
}
