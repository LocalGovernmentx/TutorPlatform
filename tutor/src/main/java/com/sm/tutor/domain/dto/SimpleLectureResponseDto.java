package com.sm.tutor.domain.dto;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class SimpleLectureResponseDto {

  private Integer id;
  private String nickname;
  private Integer categoryId;
  private String title;
  private String content;
  private Double score;
  private String image;
  private List<LectureLocationDto> locations;
}
