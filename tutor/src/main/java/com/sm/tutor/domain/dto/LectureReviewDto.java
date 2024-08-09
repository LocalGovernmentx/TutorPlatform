package com.sm.tutor.domain.dto;

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
public class LectureReviewDto {

  private Integer id;
  private Integer lectureId;
  private Integer tuteeId;
  private String content;
  private Integer score;
}
