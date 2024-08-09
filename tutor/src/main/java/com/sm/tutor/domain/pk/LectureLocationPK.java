package com.sm.tutor.domain.pk;

import java.io.Serializable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class LectureLocationPK implements Serializable {

  private Integer lecture;
  private Integer location;
}
