package com.sm.tutor.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Size;
import java.time.Instant;
import java.time.LocalDate;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Entity
@Builder
@Getter
@Setter
@Table(name = "member", schema = "modu_tutor")
public class Member {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "member_id", nullable = false)
  private Integer id;

  @Size(max = 45)
  @Column(name = "name", length = 45)
  private String name;

  @Size(max = 64)
  @Column(name = "password", length = 64)
  private String password;

  @Size(max = 45)
  @Column(name = "email", length = 45)
  private String email;

  @Size(max = 45)
  @Column(name = "nickname", length = 45)
  private String nickname;

  @Size(max = 20)
  @Column(name = "phone_number", length = 20)
  private String phoneNumber;

  @Size(max = 10)
  @Column(name = "gender", length = 10)
  private Integer gender;

  @Column(name = "birth")
  private LocalDate birth;

  @Size(max = 45)
  @Column(name = "verified_oauth", length = 45)
  private boolean verifiedOauth;

  @ColumnDefault("CURRENT_TIMESTAMP")
  @Column(name = "lastlogin")
  private Instant lastlogin;

  @Size(max = 45)
  @Column(name = "type", length = 45)
  private Integer type;

  @Size(max = 45)
  @Column(name = "invite_code", length = 45)
  private String inviteCode;
}
