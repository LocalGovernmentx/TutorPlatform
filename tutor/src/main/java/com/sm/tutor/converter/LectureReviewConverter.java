package com.sm.tutor.converter;

import com.sm.tutor.domain.LectureReview;
import com.sm.tutor.domain.dto.LectureReviewDto;
import org.springframework.stereotype.Service;

@Service
public class LectureReviewConverter {

  public LectureReviewDto toDto(LectureReview lectureReview) {
    return LectureReviewDto.builder()
        .id(lectureReview.getId())
        .lectureId(lectureReview.getLecture().getId())
        .tuteeId(lectureReview.getTutee().getId())
        .content(lectureReview.getContent())
        .score(lectureReview.getScore())
        .reviewTime(lectureReview.getReviewTime())
        .online(lectureReview.getOnline())
        .build();
  }
}