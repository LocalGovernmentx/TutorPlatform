package com.sm.tutor.domain.dto;

import com.sm.tutor.domain.Lecture;
import com.sm.tutor.domain.LectureReview;
import com.sm.tutor.domain.Member;
import java.time.LocalDateTime;
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
  private LocalDateTime reviewTime;
  private Integer online;

  public LectureReview toEntity(Lecture lecture, Member tutee) {
    return new LectureReview(lecture, tutee, this.content, this.score, this.reviewTime,
        this.online);
  }
}
