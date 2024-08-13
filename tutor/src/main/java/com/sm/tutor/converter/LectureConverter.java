package com.sm.tutor.converter;

import com.sm.tutor.domain.Lecture;
import com.sm.tutor.domain.dto.LectureAgeDto;
import com.sm.tutor.domain.dto.LectureDto;
import com.sm.tutor.domain.dto.LectureImageDto;
import com.sm.tutor.domain.dto.LectureLocationDto;
import com.sm.tutor.domain.dto.LectureReviewDto;
import com.sm.tutor.domain.dto.LectureTimeDto;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class LectureConverter {

  private final LectureAgeConverter lectureAgeConverter;
  private final LectureImageConverter lectureImageConverter;
  private final LectureLocationConverter lectureLocationConverter;
  private final LectureReviewConverter lectureReviewConverter;
  private final LectureTimeConverter lectureTimeConverter;

  public LectureDto toDto(Lecture lecture) {
    List<LectureAgeDto> ages = lecture.getAges().stream()
        .map(lectureAgeConverter::toDto)
        .collect(Collectors.toList());
    List<LectureImageDto> images = lecture.getImages().stream()
        .map(lectureImageConverter::toDto)
        .collect(Collectors.toList());
    List<LectureLocationDto> locations = lecture.getLocations().stream()
        .map(lectureLocationConverter::toDto)
        .collect(Collectors.toList());
    List<LectureReviewDto> reviews = lecture.getReviews().stream()
        .map(lectureReviewConverter::toDto)
        .collect(Collectors.toList());
    List<LectureTimeDto> times = lecture.getTimes().stream()
        .map(lectureTimeConverter::toDto)
        .collect(Collectors.toList());
    return LectureDto.builder()
        .id(lecture.getId())
        .tutorId(lecture.getTutor().getId())
        .categoryId(lecture.getCategoryId())
        .title(lecture.getTitle())
        .content(lecture.getContent())
        .activation(lecture.getActivation())
        .online(lecture.getOnline())
        .tuitionMaximum(lecture.getTuitionMaximum())
        .tuitionMinimum(lecture.getTuitionMinimum())
        .tuteeNumber(lecture.getTuteeNumber())
        .gender(lecture.getGender())
        .level(lecture.getLevel())
        .ages(ages)
        .images(images)
        .locations(locations)
        .reviews(reviews)
        .times(times)
        .build();

  }
}
