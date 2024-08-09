package com.sm.tutor.domain.dto;

import java.sql.Time;
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
public class LectureTimeDto {

  private Integer id;
  private Integer lectureId;
  private Integer day;
  private Time startTime;
  private Time endTime;
}
