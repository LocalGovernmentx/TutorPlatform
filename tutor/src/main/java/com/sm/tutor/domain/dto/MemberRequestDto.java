package com.sm.tutor.domain.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.Column;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.time.LocalDate;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema(description = "회원 생성 요청 데이터")
public class MemberRequestDto {

  @NotBlank
  @Size(max = 45)
  @Schema(description = "회원 이름", example = "John Doe", maxLength = 45)
  private String name;

  @NotBlank
  @Size(max = 512)
  @Schema(description = "회원 비밀번호", example = "password123", maxLength = 512)
  private String password;

  @NotBlank
  @Email
  @Size(max = 320)
  @Schema(description = "회원 이메일 (유니크)", example = "john.doe@example.com", maxLength = 320)
  private String email;

  @NotBlank
  @Size(max = 8)
  @Schema(description = "회원 닉네임 (유니크)", example = "johndoe", maxLength = 8)
  private String nickname;

  @Size(max = 20)
  @Schema(description = "회원 전화번호 (유니크)", example = "123-456-7890", maxLength = 20)
  private String phoneNumber;

  @Size(max = 1)
  @Schema(description = "회원 성별", example = "0", maxLength = 1)
  private Integer gender;

  @Schema(description = "회원 생년월일", example = "1990-01-01")
  private LocalDate birth;

  @Size(max = 45)
  @Column(name = "type", length = 45)
  @Schema(description = "회원 유형", example = "1", maxLength = 45)
  private Integer type;
  // Getters and Setters
}
