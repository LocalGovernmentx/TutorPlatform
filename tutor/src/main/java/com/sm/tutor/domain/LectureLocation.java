package com.sm.tutor.domain;

import com.sm.tutor.domain.pk.LectureLocationPK;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
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
@IdClass(LectureLocationPK.class)
@Table(name = "lecture_location", schema = "modu_tutor")
public class LectureLocation {

  @Id
  @ManyToOne
  @OnDelete(action = OnDeleteAction.CASCADE)
  @JoinColumn(name = "lecture_id")
  private Lecture lecture;

  @Id
  @ManyToOne
  @OnDelete(action = OnDeleteAction.CASCADE)
  @JoinColumn(name = "address_id")
  private LocationData location;

  @Builder
  public LectureLocation(Lecture lecture, LocationData location) {
    this.lecture = lecture;
    this.lecture.getLocations().add(this);
    this.location = location;
  }
}

