package com.sm.tutor.domain;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapsId;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "ongoing_lecture", schema = "modu_tutor")
public class OngoingLecture {

  @EmbeddedId
  private OngoingLectureId id;

  @MapsId("lectureId")
  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "lecture_id", nullable = false)
  private Lecture lecture;

  @MapsId("tuteeMemberId")
  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "tutee_member_id", nullable = false)
  private Member tuteeMember;

  // Constructor
  public OngoingLecture(Lecture lecture, Member tuteeMember) {
    this.lecture = lecture;
    this.tuteeMember = tuteeMember;
    this.id.setLectureId(lecture.getId());
    this.id.setTuteeMemberId(tuteeMember.getId());
  }
}