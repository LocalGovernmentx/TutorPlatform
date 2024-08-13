package com.sm.tutor.domain;

import io.swagger.v3.oas.annotations.media.Schema; // Swagger v3
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Size;
import java.time.Instant;
import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.annotations.ColumnDefault;

@Entity
@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Table(name = "member", schema = "modu_tutor")
@Schema(description = "회원 정보")
public class Member {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "member_id", nullable = false)
  @Schema(description = "회원 ID (자동 생성)", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
  private Integer id;

  @Size(max = 45)
  @Column(name = "name", length = 45)
  @Schema(description = "회원 이름", example = "John Doe", maxLength = 45)
  private String name;

  @Size(max = 512)
  @Column(name = "password", length = 512)
  @Schema(description = "회원 비밀번호", example = "password123", maxLength = 512)
  private String password;

  @Size(max = 45)
  @Column(name = "email", length = 45, unique = true)
  @Schema(description = "회원 이메일 (유니크)", example = "john.doe@example.com", maxLength = 45)
  private String email;

  @Size(max = 45)
  @Column(name = "nickname", length = 45, unique = true)
  @Schema(description = "회원 닉네임 (유니크)", example = "johndoe", maxLength = 45)
  private String nickname;

  @Size(max = 20)
  @Column(name = "phone_number", length = 20, unique = true)
  @Schema(description = "회원 전화번호 (유니크)", example = "123-456-7890", maxLength = 20)
  private String phoneNumber;

  @Size(max = 10)
  @Column(name = "gender", length = 10)
  @Schema(description = "회원 성별 (예: 'Male', 'Female', 'Other')", example = "Male", maxLength = 10)
  private Integer gender;

  @Column(name = "birth")
  @Schema(description = "회원 생년월일", example = "1990-01-01")
  private LocalDate birth;

  @Size(max = 45)
  @Column(name = "verified_oauth", length = 45)
  @Schema(description = "OAuth 인증 여부", example = "true", maxLength = 45)
  private Boolean verifiedOauth;

  @ColumnDefault("CURRENT_TIMESTAMP")
  @Column(name = "lastlogin")
  @Schema(description = "마지막 로그인 시간", example = "2024-08-13T12:00:00Z")
  private Instant lastlogin;

  @Size(max = 45)
  @Column(name = "type", length = 45)
  @Schema(description = "회원 유형", example = "1", maxLength = 45)
  private Integer type;

  @Size(max = 45)
  @Column(name = "invite_code", length = 45)
  @Schema(description = "초대 코드", example = "INVITE123", maxLength = 45)
  private String inviteCode;

  @Size(max = 200)
  @Column(name = "image", length = 200)
  @Schema(description = "회원 프로필 이미지 URL", example = "https://example.com/profile.jpg", maxLength = 200)
  private String image;
}
