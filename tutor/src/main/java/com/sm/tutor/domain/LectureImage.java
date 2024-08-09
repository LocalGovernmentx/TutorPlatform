package com.sm.tutor.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Getter
@Setter
@NoArgsConstructor
@Table(name = "lecture_image", schema = "modu_tutor")
public class LectureImage {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "lecture_image_id", nullable = false)
  private Integer id;

  @ManyToOne
  @OnDelete(action = OnDeleteAction.CASCADE)
  @JoinColumn(name = "lecture_id")
  private Lecture lecture;

  @Column(name = "image", nullable = false)
  private String image;

  @Column(name = "main_image", nullable = false)
  private Boolean mainImage;

  @Builder
  public LectureImage(Lecture lecture, String image, Boolean mainImage) {
    this.lecture = lecture;
    this.lecture.getImages().add(this);
    this.image = image;
    this.mainImage = mainImage;
  }
}