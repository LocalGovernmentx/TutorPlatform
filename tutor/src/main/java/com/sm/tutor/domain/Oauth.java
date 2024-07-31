package com.sm.tutor.domain;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
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
public class Oauth {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "oauth_id", nullable = false)
  private Integer id;

  @Column(name = "member_id")
  private Integer memberId;

  // provider : google
  private String provider;

  @Column(name = "provider_id")
  // providerId : 구굴 로그인 한 유저의 고유 ID가 들어감
  private String providerId;
}
