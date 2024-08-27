package com.sm.tutor.converter;

import com.sm.tutor.domain.Lecture;
import com.sm.tutor.domain.LectureImage;
import com.sm.tutor.domain.LectureReview;
import com.sm.tutor.domain.dto.LectureLocationDto;
import com.sm.tutor.domain.dto.SimpleLectureResponseDto;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class SimpleLectureConverter {

  private final LectureAgeConverter lectureAgeConverter;
  private final LectureImageConverter lectureImageConverter;
  private final LectureLocationConverter lectureLocationConverter;
  private final LectureReviewConverter lectureReviewConverter;
  private final LectureTimeConverter lectureTimeConverter;

  public SimpleLectureResponseDto toDto(Lecture lecture) {
    String image = null; // main image 만 골라내기
    for (LectureImage lectureImage : lecture.getImages()) {
      if (lectureImage.getMainImage()) {
        image = lectureImage.getImage();
      }
    }
    List<LectureLocationDto> locations = lecture.getLocations().stream()
        .map(lectureLocationConverter::toDto)
        .collect(Collectors.toList());
    Double score = 0.0;
    for (LectureReview review : lecture.getReviews()) {
      score += review.getScore();
    }
    if (lecture.getReviews().size()) {
      score /= lecture.getReviews().size();
    }
    return SimpleLectureResponseDto.builder()
        .id(lecture.getId())
        .nickname(lecture.getTutor().getMember().getNickname())
        .categoryId(lecture.getCategoryId())
        .title(lecture.getTitle())
        .content(lecture.getContent())
        .image(image)
        .locations(locations)
        .score(score)
        .build();
  }
}
