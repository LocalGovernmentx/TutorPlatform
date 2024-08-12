package com.sm.tutor.converter;

import com.sm.tutor.domain.LectureTime;
import com.sm.tutor.domain.dto.LectureTimeDto;
import org.springframework.stereotype.Service;

@Service
public class LectureTimeConverter {

  public LectureTimeDto toDto(LectureTime lectureTime) {
    return LectureTimeDto.builder()
        .id(lectureTime.getId())
        .lectureId(lectureTime.getLecture().getId())
        .day(lectureTime.getDay())
        .startTime(lectureTime.getStartTime())
        .endTime(lectureTime.getEndTime())
        .build();
  }
}