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
import java.time.LocalDateTime;
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
@Table(name = "lecture_review", schema = "modu_tutor")
public class LectureReview {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "lecture_review_id", nullable = false)
  private Integer id;

  @ManyToOne(fetch = FetchType.LAZY)
  @OnDelete(action = OnDeleteAction.CASCADE)
  @JoinColumn(name = "lecture_id")
  private Lecture lecture;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "tutee_member_id", nullable = false)
  private Member tutee;

  @Column(name = "content", nullable = false)
  private String content;

  @Column(name = "score", nullable = false)
  private Integer score;

  @Column(name = "review_time", nullable = false)
  private LocalDateTime reviewTime;

  @Column(name = "online", nullable = false)
  private Integer online;

  @Builder
  public LectureReview(Lecture lecture, Member tutee, String content, Integer score,
      LocalDateTime reviewTime, Integer online) {
    this.lecture = lecture;
    this.lecture.getReviews().add(this);
    this.tutee = tutee;
    this.content = content;
    this.score = score;
    this.reviewTime = reviewTime;
    this.online = online;
  }
}