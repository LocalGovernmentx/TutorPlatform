package com.sm.tutor.domain;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapsId;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "dibs", schema = "modu_tutor")
public class Dibs {

  @EmbeddedId
  private DibsId id;

  @MapsId("lectureId")
  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "lecture_id", nullable = false)
  private Lecture lecture;

  @MapsId("tuteeMemberId")
  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "tutee_member_id", nullable = false)
  private Member tuteeMember;

}