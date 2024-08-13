package com.sm.tutor.domain.dto;

import com.sm.tutor.domain.Lecture;
import com.sm.tutor.domain.LectureLocation;
import com.sm.tutor.domain.LocationData;
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
public class LectureLocationDto {

  private Integer lectureId;
  private Integer locationId;

  public LectureLocation toEntity(Lecture lecture, LocationData location) {
    return new LectureLocation(lecture, location);
  }
}
