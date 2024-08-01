package com.sm.tutor.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.time.Instant;
import java.time.LocalDate;
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
public class Member {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "member_id", nullable = false)
  private Integer id;

  @Size(max = 320)
  @NotNull
  @Column(name = "email", nullable = false, length = 320)
  private String email;

  @Size(max = 512)
  @NotNull
  @Column(name = "password", nullable = false, length = 512)
  private String password;

  @Size(max = 50)
  @NotNull
  @Column(name = "nickname", nullable = false, length = 50)
  private String nickname;

  @Size(max = 50)
  @NotNull
  @Column(name = "name", nullable = false, length = 50)
  private String name;

  @Size(max = 50)
  @NotNull
  @Column(name = "phone_number", nullable = false, length = 50)
  private String phoneNumber;

  @NotNull
  @Column(name = "gender", nullable = false)
  private Integer gender;

  @NotNull
  @Column(name = "birth", nullable = false)
  private LocalDate birth;

  @NotNull
  @Column(name = "verified_oauth", nullable = false)
  private Boolean verifiedOauth;

  @NotNull
  @Column(name = "lastlogin", nullable = false)
  private Instant lastlogin;

  @NotNull
  @Column(name = "type", nullable = false)
  private Integer type;

  @Size(max = 20)
  @Column(name = "invite_code", length = 20)
  private String inviteCode;

}
