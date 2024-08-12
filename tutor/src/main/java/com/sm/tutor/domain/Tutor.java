package com.sm.tutor.domain;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.MapsId;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import java.util.ArrayList;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "tutor", schema = "modu_tutor")
public class Tutor {

  @Id
  @Column(name = "member_id")
  private Integer id;

  @Column(name = "introduction", nullable = false)
  private String introduction;

  @Column(name = "job", nullable = false)
  private String job;

  @OneToOne
  @MapsId
  @Setter
  @JoinColumn(name = "member_id")
  private Member member;

  @OneToMany(mappedBy = "tutor", cascade = CascadeType.ALL)
  private List<Lecture> lectures = new ArrayList<>();
}

