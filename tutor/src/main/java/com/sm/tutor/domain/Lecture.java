package com.sm.tutor.domain;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.util.ArrayList;
import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Getter
@Setter
@NoArgsConstructor
@ToString
@Table(name = "lecture", schema = "modu_tutor")
public class Lecture {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "lecture_id", nullable = false)
  private Integer id;

  @ManyToOne(fetch = FetchType.LAZY)
  @OnDelete(action = OnDeleteAction.CASCADE)
  @JoinColumn(name = "member_id", nullable = false)
  private Tutor tutor;

  @Column(name = "category_id", nullable = false)
  private Integer categoryId;

  @Column(name = "title", nullable = false)
  private String title;

  @Column(name = "content", nullable = false)
  private String content;

  @Column(name = "activation", nullable = false, columnDefinition = "TINYINT")
  private Boolean activation;

  @Column(name = "online", nullable = false)
  private Integer online;

  @Column(name = "tuition_maximum", nullable = false)
  private Integer tuitionMaximum;

  @Column(name = "tuition_minimum", nullable = false)
  private Integer tuitionMinimum;

  @Column(name = "tutee_number")
  private Integer tuteeNumber;

  @Column(name = "gender")
  private Integer gender;

  @Column(name = "level", nullable = false)
  private Integer level;

  @OneToMany(mappedBy = "lecture", cascade = CascadeType.ALL)
  private List<LectureAge> ages = new ArrayList<>();

  @OneToMany(mappedBy = "lecture", cascade = CascadeType.ALL)
  private List<LectureImage> images = new ArrayList<>();

  @OneToMany(mappedBy = "lecture", cascade = CascadeType.ALL)
  private List<LectureLocation> locations = new ArrayList<>();

  @OneToMany(mappedBy = "lecture", cascade = CascadeType.ALL)
  private List<LectureReview> reviews = new ArrayList<>();

  @OneToMany(mappedBy = "lecture", cascade = CascadeType.ALL)
  private List<LectureTime> times = new ArrayList<>();

  @Builder
  public Lecture(Tutor tutor, Integer categoryId, String title, String content, Boolean activation,
      Integer online, Integer tuitionMaximum, Integer tuitionMinimum, Integer tuteeNumber,
      Integer gender, Integer level, List<LectureAge> ages, List<LectureImage> images,
      List<LectureLocation> locations, List<LectureReview> reviews, List<LectureTime> times) {
    this.tutor = tutor;
    this.tutor.getLectures().add(this);
    this.categoryId = categoryId;
    this.title = title;
    this.content = content;
    this.activation = activation;
    this.online = online;
    this.tuitionMaximum = tuitionMaximum;
    this.tuitionMinimum = tuitionMinimum;
    this.tuteeNumber = tuteeNumber;
    this.gender = gender;
    this.level = level;
    this.ages = ages;
    this.images = images;
    this.locations = locations;
    this.reviews = reviews;
    this.times = times;
  }
}