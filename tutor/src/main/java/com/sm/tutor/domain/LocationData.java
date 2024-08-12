package com.sm.tutor.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "location_data", schema = "modu_tutor")
public class LocationData {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "location_id", nullable = false)
  private Integer id;

  @Column(name = "city", nullable = false)
  private String city;

  @Column(name = "district", nullable = false)
  private String district;

  @Column(name = "dong", nullable = false)
  private String dong;
}