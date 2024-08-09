package com.sm.tutor.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.sql.Time;
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
@Table(name = "lecture_time", schema = "modu_tutor")
public class LectureTime {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "lecture_time_id", nullable = false)
  private Integer id;

  @ManyToOne
  @OnDelete(action = OnDeleteAction.CASCADE)
  @JoinColumn(name = "lecture_id")
  private Lecture lecture;

  @Column(name = "day", nullable = false)
  private Integer day;

  @Column(name = "start_time")
  private Time startTime;

  @Column(name = "end_time")
  private Time endTime;

  @Builder
  public LectureTime(Lecture lecture, Integer day, Time startTime, Time endTime) {
    this.lecture = lecture;
    this.lecture.getTimes().add(this);
    this.day = day;
    this.startTime = startTime;
    this.endTime = endTime;
  }
}