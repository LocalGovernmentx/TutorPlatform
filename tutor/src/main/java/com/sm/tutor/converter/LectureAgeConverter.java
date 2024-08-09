package com.sm.tutor.converter;

import com.sm.tutor.domain.LectureAge;
import com.sm.tutor.domain.dto.LectureAgeDto;
import org.springframework.stereotype.Service;

@Service
public class LectureAgeConverter {

  public LectureAgeDto toDto(LectureAge lectureAge) {
    return LectureAgeDto.builder()
        .id(lectureAge.getId())
        .lectureId(lectureAge.getLecture().getId())
        .age(lectureAge.getAge())
        .build();
  }
}
