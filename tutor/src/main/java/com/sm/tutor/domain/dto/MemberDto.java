package com.sm.tutor.domain.dto;

import com.sm.tutor.domain.Member;
import java.time.Instant;
import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MemberDto {

  private Integer id;
  private String name;
  private String password;
  private String email;
  private String nickname;
  private String phoneNumber;
  private Integer gender;
  private LocalDate birth;
  private Boolean verifiedOauth;
  private Instant lastlogin;
  private Integer type;
  private String inviteCode;
  private String image;
//  private Integer tutorId;

  public Member toEntity(/*Tutor tutor*/) {
    Member member = Member.builder()
        .id(this.id)
        .name(this.name)
        .password(this.password)
        .email(this.email)
        .nickname(this.nickname)
        .phoneNumber(this.phoneNumber)
        .gender(this.gender)
        .birth(this.birth)
        .verifiedOauth(this.verifiedOauth)
        .lastlogin(this.lastlogin)
        .type(this.type)
        .inviteCode(this.inviteCode)
        .image(this.image)
        .build();
    /*if (tutor != null) {
      member.setTutorId(tutor.getId());
    }*/
    return member;
  }
}
