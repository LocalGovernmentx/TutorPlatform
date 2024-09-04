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
public class LectureSmallView {

  private Integer id;
  private String tutorNickname;
  private Integer categoryId;
  private String title;
  private Boolean activation;
  private String mainImage;
  private List<LectureLocationDto> locations;

}
