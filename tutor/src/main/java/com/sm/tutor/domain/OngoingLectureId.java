package com.sm.tutor.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;
import java.util.Objects;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Embeddable
public class OngoingLectureId implements java.io.Serializable {

  private static final long serialVersionUID = 7582582758471138953L;

  @NotNull
  @Column(name = "lecture_id", nullable = false)
  private Integer lectureId;

  @NotNull
  @Column(name = "tutee_member_id", nullable = false)
  private Integer tuteeMemberId;

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    OngoingLectureId that = (OngoingLectureId) o;
    return Objects.equals(this.tuteeMemberId, that.tuteeMemberId) &&
        Objects.equals(this.lectureId, that.lectureId);
  }

  @Override
  public int hashCode() {
    return Objects.hash(tuteeMemberId, lectureId);
  }

}
