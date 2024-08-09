package com.sm.tutor.converter;

import com.sm.tutor.domain.LectureLocation;
import com.sm.tutor.domain.dto.LectureLocationDto;
import org.springframework.stereotype.Service;

@Service
public class LectureLocationConverter {

  public LectureLocationDto toDto(LectureLocation lectureLocation) {
    return LectureLocationDto.builder()
        .lectureId(lectureLocation.getLecture().getId())
        .locationId(lectureLocation.getLocation().getId())
        .build();
  }
}