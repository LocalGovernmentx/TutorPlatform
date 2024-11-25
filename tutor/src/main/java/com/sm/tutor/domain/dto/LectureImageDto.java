package com.sm.tutor.domain.dto;

import com.sm.tutor.domain.Lecture;
import com.sm.tutor.domain.LectureImage;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LectureImageDto {

  private Integer id;
  private Integer lectureId;
  private String image;
  private Boolean mainImage;

  public LectureImage toEntity(Lecture lecture) {
    return new LectureImage(lecture, this.image, this.mainImage != null ? this.mainImage : false);
  }
}
