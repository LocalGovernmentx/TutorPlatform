package com.sm.tutor.domain.dto;

import java.util.List;
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
public class LectureDto {

  private Integer id;
  private Integer tutorId;
  private Integer categoryId;
  private String title;
  private String content;
  private Boolean activation;
  private Integer online;
  private Integer tuitionMaximum;
  private Integer tuitionMinimum;
  private Integer tuteeNumber;
  private Integer gender;
  private Integer level;
  private List<LectureAgeDto> ages;
  private List<LectureImageDto> images;
  private List<LectureLocationDto> locations;
  private List<LectureReviewDto> reviews;
  private List<LectureTimeDto> times;
}
