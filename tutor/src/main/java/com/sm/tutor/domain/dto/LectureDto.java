package com.sm.tutor.domain.dto;

import com.sm.tutor.domain.Lecture;
import com.sm.tutor.domain.LectureAge;
import com.sm.tutor.domain.LectureImage;
import com.sm.tutor.domain.LectureLocation;
import com.sm.tutor.domain.LectureReview;
import com.sm.tutor.domain.LectureTime;
import com.sm.tutor.domain.Tutor;
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
public class LectureDto {

  private Integer id;
  private Integer tutorId;
  private Integer categoryId;
  private String title;
  private String content;
  private Boolean activation;
  private Integer online;
  private Integer tuitionMaximum;
  private Integer tuitionMinimum;
  private Integer tuteeNumber;
  private Integer gender;
  private Integer level;
  private List<LectureAgeDto> ages;
  private List<LectureImageDto> images;
  private List<LectureLocationDto> locations;
  private List<LectureReviewDto> reviews;
  private List<LectureTimeDto> times;

  public Lecture toEntity(Tutor tutor, List<LectureAge> ages, List<LectureImage> images,
      List<LectureLocation> locations, List<LectureReview> reviews, List<LectureTime> times) {
    return new Lecture(tutor, this.categoryId, this.title, this.content, this.activation,
        this.online, this.tuitionMaximum,
        this.tuitionMinimum, this.tuteeNumber, this.gender, this.level, ages, images, locations,
        reviews, times);
  }
}
