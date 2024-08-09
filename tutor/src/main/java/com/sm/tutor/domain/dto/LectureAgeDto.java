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
public class LectureAgeDto {

  private Integer id;
  private Integer lectureId;
  private Integer age;
}
