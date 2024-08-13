package com.sm.tutor.converter;

import com.sm.tutor.domain.LectureImage;
import com.sm.tutor.domain.dto.LectureImageDto;
import org.springframework.stereotype.Service;

@Service
public class LectureImageConverter {

  public LectureImageDto toDto(LectureImage lectureImage) {
    return LectureImageDto.builder()
        .id(lectureImage.getId())
        .lectureId(lectureImage.getLecture().getId())
        .image(lectureImage.getImage())
        .mainImage(lectureImage.getMainImage())
        .build();
  }
}