package com.sm.tutor.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;
import java.util.Objects;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.Hibernate;

@Getter
@Setter
@Embeddable
public class DibsId implements java.io.Serializable {

  private static final long serialVersionUID = 482789589598831218L;
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
    if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) {
      return false;
    }
    DibsId entity = (DibsId) o;
    return Objects.equals(this.tuteeMemberId, entity.tuteeMemberId) &&
        Objects.equals(this.lectureId, entity.lectureId);
  }

  @Override
  public int hashCode() {
    return Objects.hash(tuteeMemberId, lectureId);
  }

}