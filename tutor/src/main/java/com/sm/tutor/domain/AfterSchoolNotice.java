package com.sm.tutor.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Getter
@Setter
@NoArgsConstructor
@ToString
@Table(name = "after_school_notice", schema = "modu_tutor")
public class AfterSchoolNotice {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "after_school_notice_id", nullable = false)
  private Integer id;

  @Column(name = "title", nullable = false)
  private String title;

  @Column(name = "content", nullable = false)
  private String content;

  @Column(name = "region", nullable = false)
  private String region;

  @Column(name = "key_value", nullable = false)
  private String keyValue;

  @Column(name = "file_content")
  private String fileContent;

  @Column(name = "file_path")
  private String filePath;

}
