package com.sm.tutor.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
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
@Table(name = "lecture_age", schema = "modu_tutor")
public class LectureAge {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "lecture_age_id", nullable = false)
  private Integer id;

  @ManyToOne(fetch = FetchType.LAZY)
  @OnDelete(action = OnDeleteAction.CASCADE)
  @JoinColumn(name = "lecture_id")
  private Lecture lecture;

  @Column(name = "age", nullable = false)
  private Integer age;

  @Builder
  public LectureAge(Lecture lecture, Integer age) {
    this.lecture = lecture;
    this.lecture.getAges().add(this);
    this.age = age;
  }
}