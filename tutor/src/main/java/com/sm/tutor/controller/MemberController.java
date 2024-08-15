package com.sm.tutor.controller;

import com.sm.tutor.config.JwtTokenProvider;
import com.sm.tutor.domain.Member;
import com.sm.tutor.domain.dto.MemberRequestDto;
import com.sm.tutor.service.MemberService;
import com.sm.tutor.util.EmailValidator;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/members")
public class MemberController {

  @Autowired
  private final JwtTokenProvider tokenProvider;
  @Autowired
  private MemberService memberService;
  @Autowired
  private PasswordEncoder passwordEncoder;

  public MemberController(JwtTokenProvider tokenProvider) {
    this.tokenProvider = tokenProvider;
  }


  @Operation(summary = "모든 멤버 조회", description = "개발용")
  @GetMapping
  public ResponseEntity<List<Member>> getAllMembers() {
    List<Member> members = memberService.getAllMembers();
    return new ResponseEntity<>(members, HttpStatus.OK);
  }

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: 성공", content = {
          @Content(schema = @Schema(implementation = Member.class))}),
      @ApiResponse(responseCode = "404", description = "NOT_FOUND: Member not found")
  })
  @Operation(summary = "내 정보 조회",
      description = "오른쪽위 authorize에 토큰값 넣기\n" +
          "현재 로그인된 사용자의 정보를 조회합니다. \n" +
          "요청에 포함된 토큰에서 이메일을 추출하여 해당 사용자의 정보를 검색합니다. \n" +
          "사용자를 찾을 수 없는 경우 `404 Not Found` 상태 코드와 함께 에러 메시지를 반환합니다. \n" +
          "성공적으로 사용자 정보를 조회하면 `200 OK` 상태 코드와 함께 반환됩니다.")
  @GetMapping("/me")
  public ResponseEntity<?> getMyInfo(HttpServletRequest request) {
    String email = (String) request.getAttribute("userEmail");
    Member member = memberService.getMemberByEmail(email);
    if (member != null) {
      return new ResponseEntity<>(member, HttpStatus.OK);
    } else {
      return new ResponseEntity<>(Collections.singletonMap("message", "Member not found"),
          HttpStatus.NOT_FOUND);
    }
  }

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: Member created successfully"),
      @ApiResponse(responseCode = "422", description = "UNPROCESSABLE_ENTITY: Invalid email format"),
      @ApiResponse(responseCode = "411", description = "LENGTH_REQUIRED: Password is too short"),
      @ApiResponse(responseCode = "400", description = "BAD_REQUEST: Nickname must be between 2 and 8 characters long"),
      @ApiResponse(responseCode = "409", description = "CONFLICT: Nickname is already in use"),
      @ApiResponse(responseCode = "406", description = "NOT_ACCEPTABLE: Phone number is already in use"),
      @ApiResponse(responseCode = "403", description = "FORBIDDEN: Email is not verified"),
      @ApiResponse(responseCode = "409", description = "CONFLICT: Email is already in use")
  })
  @Operation(summary = "회원가입",
      description =
          "1. **이메일 형식 검증**: 유효하지 않은 이메일 형식인 경우, `422 Unprocessable Entity` 상태 코드와 'Invalid email format' 메시지를 반환합니다.\n"
              +
              "2. **비밀번호 길이 검증**: 비밀번호 길이가 8자 미만인 경우, `411 Length Required` 상태 코드와 'Password is too short' 메시지를 반환합니다.\n"
              +
              "3. **닉네임 길이 검증**: 닉네임 길이가 2자 미만 또는 8자 초과인 경우, `400 Bad Request` 상태 코드와 'Nickname must be between 2 and 8 characters long' 메시지를 반환합니다.\n"
              +
              "4. **닉네임 중복 검증**: 닉네임이 이미 사용 중인 경우, `409 Conflict` 상태 코드와 'Nickname is already in use' 메시지를 반환합니다.\n"
              +
              "5. **전화번호 중복 검증**: 전화번호가 이미 사용 중인 경우, `406 Not Acceptable` 상태 코드와 'Phone number is already in use' 메시지를 반환합니다.\n"
              +
              "6. **이메일 인증 여부 검증**: 이메일이 인증되지 않은 경우, `403 Forbidden` 상태 코드와 'Email is not verified' 메시지를 반환합니다.\n"
              +
              "7. **이메일 중복 검증**: 이메일이 이미 사용 중인 경우, `409 Conflict` 상태 코드와 'Email is already in use' 메시지를 반환합니다.\n"
              +
              "회원 가입이 성공적으로 처리된 경우, `200 OK` 상태 코드와 'Member created successfully' 메시지를 반환합니다.\n")
  @PostMapping
  public ResponseEntity<?> createMember(@RequestBody MemberRequestDto member) {
    // 이메일 형식 검증
    if (!EmailValidator.isValidEmail(member.getEmail())) {
      return new ResponseEntity<>(
          Collections.singletonMap("message", "Invalid email format"),
          HttpStatus.UNPROCESSABLE_ENTITY // 422 Unprocessable Entity: 요청을 이해했으나 처리할 수 없는 경우
      );
    }

    // 비밀번호 길이 검증
    if (member.getPassword().length() < 8) {
      return new ResponseEntity<>(
          Collections.singletonMap("message", "Password is too short"),
          HttpStatus.LENGTH_REQUIRED // 411 Length Required: 요청에 필요한 길이가 충족되지 않는 경우
      );
    }

    // 닉네임 길이 검증
    if (member.getNickname().length() < 2 || member.getNickname().length() > 8) {
      return new ResponseEntity<>(
          Collections.singletonMap("message", "Nickname must be between 2 and 8 characters long"),
          HttpStatus.BAD_REQUEST // 400 Bad Request: 클라이언트 요청이 잘못된 경우
      );
    }

    // 닉네임 중복 검증
    if (memberService.checkNickname(member.getNickname())) {
      return new ResponseEntity<>(
          Collections.singletonMap("message", "Nickname is already in use"),
          HttpStatus.CONFLICT // 409 Conflict: 닉네임이 이미 사용 중인 경우
      );
    }

    // 전화번호 중복 검증
    if (memberService.checkPhoneNumber(member.getPhoneNumber())) {
      return new ResponseEntity<>(
          Collections.singletonMap("message", "Phone number is already in use"),
          HttpStatus.NOT_ACCEPTABLE // 406 Not Acceptable: 요청된 자원이 수용할 수 없는 경우
      );
    }

    // 이메일 인증 여부 검증
    String verificationStatus = memberService.getEmailVerificationStatus(member.getEmail());
    if ("unverified".equals(verificationStatus)) {
      return new ResponseEntity<>(
          Collections.singletonMap("message", "Email is not verified"),
          HttpStatus.FORBIDDEN // 403 Forbidden: 요청이 서버에서 거부된 경우
      );
    }

    // 이메일 중복 검증
    if (memberService.getMemberByEmail(member.getEmail()) != null) {
      return new ResponseEntity<>(
          Collections.singletonMap("message", "Email is already in use"),
          HttpStatus.CONFLICT // 409 Conflict: 이메일이 이미 사용 중인 경우
      );
    }

    // 회원 가입 처리
    Member createdMember = memberService.saveMember(member);
    return new ResponseEntity<>(
        Collections.singletonMap("message", "Member created successfully"),
        HttpStatus.OK
    );
  }

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: Email is available"),
      @ApiResponse(responseCode = "422", description = "UNPROCESSABLE_ENTITY: Invalid email format"),
      @ApiResponse(responseCode = "409", description = "CONFLICT: Nickname is already in use")
  })
  @Operation(summary = "이메일 중복확인",
      description = "이메일의 중복 여부를 확인합니다. \n" +
          "요청된 이메일이 유효한지 검증하고, 데이터베이스에서 해당 이메일이 존재하는지 확인합니다. \n" +
          "이메일 형식이 유효하지 않은 경우 `400 Bad Request` 상태 코드와 함께 에러 메시지를 반환합니다. \n" +
          "이메일이 이미 사용 중인 경우 `409 Conflict` 상태 코드와 함께 에러 메시지를 반환합니다. \n" +
          "이메일이 사용 중이지 않은 경우 `200 OK` 상태 코드와 함께 사용 가능 메시지를 반환합니다.")
  @GetMapping("/check-email")
  public ResponseEntity<?> checkEmailDuplicate(@RequestParam String email) {
    if (!EmailValidator.isValidEmail(email)) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Invalid email format"),
          HttpStatus.BAD_REQUEST);
    }
    Member member = memberService.getMemberByEmail(email);
    if (member != null) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Email is already in use"),
          HttpStatus.CONFLICT);
    } else {
      return new ResponseEntity<>(Collections.singletonMap("message", "Email is available"),
          HttpStatus.OK);
    }
  }

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: Nickname is available"),
      @ApiResponse(responseCode = "409", description = "CONFLICT: Nickname is already in use")
  })
  @Operation(summary = "닉네임 중복확인",
      description = "닉네임의 중복 여부를 확인합니다. \n" +
          "요청된 닉네임이 데이터베이스에 이미 존재하는지 확인합니다. \n" +
          "닉네임이 이미 사용 중인 경우 `409 Conflict` 상태 코드와 함께 에러 메시지를 반환합니다. \n" +
          "닉네임이 사용 중이지 않은 경우 `200 OK` 상태 코드와 함께 사용 가능 메시지를 반환합니다.")
  @GetMapping("/check-nickname")
  public ResponseEntity<?> checkNicknameDuplicate(@RequestParam String nickname) {
    boolean isDuplicate = memberService.checkNickname(nickname);
    if (isDuplicate) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Nickname is already in use"),
          HttpStatus.CONFLICT);
    } else {
      return new ResponseEntity<>(Collections.singletonMap("message", "Nickname is available"),
          HttpStatus.OK);
    }
  }

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: Member resigned successfully"),
      @ApiResponse(responseCode = "404", description = "NOT_FOUND: Member not found")
  })
  @Operation(summary = "회원탈퇴",
      description = "현재 로그인된 사용자를 삭제합니다. \n" +
          "요청에 포함된 토큰에서 이메일을 추출하여 해당 사용자를 검색합니다. \n" +
          "사용자를 찾을 수 없는 경우 `404 Not Found` 상태 코드와 함께 에러 메시지를 반환합니다. \n" +
          "회원 탈퇴가 성공적으로 처리되면 `200 OK` 상태 코드와 함께 성공 메시지를 반환합니다.")
  @DeleteMapping("/resign")
  public ResponseEntity<?> deleteMember(HttpServletRequest request) {
    String email = (String) request.getAttribute("userEmail");
    if (memberService.getMemberByEmail(email) == null) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Member not found"),
          HttpStatus.NOT_FOUND);
    }
    memberService.deleteMember(email);
    return new ResponseEntity<>(Collections.singletonMap("message", "Member resigned successfully"),
        HttpStatus.OK);
  }

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: 성공"),
      @ApiResponse(responseCode = "404", description = "NOT_FOUND: Member not found"),
      @ApiResponse(responseCode = "401", description = "UNAUTHORIZED: Invalid password")
  })
  @Operation(summary = "로그인",
      description = "이메일과 비밀번호를 사용하여 로그인합니다. \n" +
          "요청된 이메일이 데이터베이스에 존재하지 않거나 비밀번호가 일치하지 않는 경우 각각 `404 Not Found` 또는 `401 Unauthorized` 상태 코드와 함께 에러 메시지를 반환합니다. \n"
          +
          "로그인이 성공하면 새로운 액세스 토큰과 리프레시 토큰을 생성하여 반환하며, `200 OK` 상태 코드와 함께 반환됩니다.")
  @PostMapping("/login")
  public ResponseEntity<?> login(@RequestParam String email, @RequestParam String password) {
    Member member = memberService.getMemberByEmail(email);
    if (member == null) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Member not found"),
          HttpStatus.NOT_FOUND);
    }
    if (!passwordEncoder.matches(password, member.getPassword())) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Invalid password"),
          HttpStatus.UNAUTHORIZED);
    }
    String accessToken = tokenProvider.createAccessToken(email);
    String refreshToken = tokenProvider.createRefreshToken(email);
    Map<String, String> response = new HashMap<>();
    response.put("accessToken", "Bearer " + accessToken);
    response.put("refreshToken", refreshToken);
    return new ResponseEntity<>(response, HttpStatus.OK);
  }

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: Logout successful"),
      @ApiResponse(responseCode = "401", description = "UNAUTHORIZED: Invalid token")
  })
  @Operation(summary = "로그아웃",
      description = "현재 로그인된 사용자의 리프레시 토큰을 삭제하여 로그아웃을 처리합니다. \n" +
          "요청에 포함된 토큰에서 이메일을 추출하고, 해당 이메일로 리프레시 토큰을 삭제합니다. \n" +
          "토큰이 유효하지 않은 경우 `401 Unauthorized` 상태 코드와 함께 에러 메시지를 반환합니다. \n" +
          "로그아웃이 성공적으로 처리되면 `200 OK` 상태 코드와 함께 성공 메시지를 반환합니다.")
  @PostMapping("/logout")
  public ResponseEntity<?> logout(HttpServletRequest request) {
    String email = (String) request.getAttribute("userEmail");
    if (email == null) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Invalid token"),
          HttpStatus.UNAUTHORIZED);
    }
    tokenProvider.deleteRefreshToken(email);
    return new ResponseEntity<>(Collections.singletonMap("message", "Logout successful"),
        HttpStatus.OK);
  }

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: 성공"),
      @ApiResponse(responseCode = "401", description = "UNAUTHORIZED: Invalid refresh token")
  })
  @Operation(summary = "리프레시 토큰으로 액세스 토큰 재발급",
      description = "리프레시 토큰을 사용하여 새로운 액세스 토큰을 발급받습니다. \n" +
          "요청된 리프레시 토큰이 유효하지 않은 경우 `401 Unauthorized` 상태 코드와 함께 에러 메시지를 반환합니다. \n" +
          "리프레시 토큰이 유효하면 새로운 액세스 토큰을 생성하여 반환하며, `200 OK` 상태 코드와 함께 반환됩니다.")
  @PostMapping("/refresh")
  public ResponseEntity<?> refreshToken(@RequestParam String userEmail,
      @RequestParam String refreshToken) {
    if (!tokenProvider.validateRefreshToken(userEmail, refreshToken)) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Invalid refresh token"),
          HttpStatus.UNAUTHORIZED);
    }
    String newAccessToken = tokenProvider.createAccessToken(userEmail);
    return new ResponseEntity<>(Collections.singletonMap("accessToken", "Bearer " + newAccessToken),
        HttpStatus.OK);
  }

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: Verification code sent"),
      @ApiResponse(responseCode = "400", description = "BAD_REQUEST: Invalid email format")
  })
  @Operation(summary = "이메일 인증 코드 전송 요청",
      description = "지정된 이메일 주소로 인증 코드를 전송합니다. \n" +
          "요청된 이메일이 유효하지 않은 경우 `400 Bad Request` 상태 코드와 함께 에러 메시지를 반환합니다. \n" +
          "인증 코드 전송이 성공적으로 처리되면 `200 OK` 상태 코드와 함께 성공 메시지를 반환합니다.")
  @PostMapping("/emails/verification-requests")
  public ResponseEntity<?> sendVerificationCode(@RequestParam("email") String email) {
    if (!EmailValidator.isValidEmail(email)) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Invalid email format"),
          HttpStatus.BAD_REQUEST);
    }
    memberService.sendCodeToEmail(email);
    return new ResponseEntity<>(Collections.singletonMap("message", "Verification code sent"),
        HttpStatus.OK);
  }

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: Email verified successfully"),
      @ApiResponse(responseCode = "400", description = "BAD_REQUEST: Invalid email format"),
      @ApiResponse(responseCode = "404", description = "NOT_FOUND: Email not found"),
      @ApiResponse(responseCode = "400", description = "BAD_REQUEST: Invalid verification code")
  })
  @Operation(summary = "이메일 인증 코드 확인 - 비밀번호 찾기할 때 사용",
      description = "이메일 인증 코드를 확인하여 비밀번호 재설정을 위한 토큰을 발급합니다. \n" +
          "요청된 이메일이 유효하지 않거나 해당 이메일이 데이터베이스에 존재하지 않는 경우 각각 `400 Bad Request` 또는 `404 Not Found` 상태 코드와 함께 에러 메시지를 반환합니다. \n"
          +
          "인증 코드가 유효하면 회원가입이 완료되었음을 알리는 메시지를 반환하며, `200 OK` 상태 코드와 함께 반환됩니다. \n" +
          "이외에 다른 사유로 이메일 인증 확인에 실패할 경우 `400 Bad Request` 상태 코드와 `Invalid verification code` 에러 메시지를 반환합니다.")
  @GetMapping("/emails/verifications")
  public ResponseEntity<?> verificationEmail(@RequestParam("email") String email,
      @RequestParam("code") String authCode) {
    if (!EmailValidator.isValidEmail(email)) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Invalid email format"),
          HttpStatus.BAD_REQUEST);

    }
    if (memberService.getMemberByEmail(email) == null) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Email not found"),
          HttpStatus.NOT_FOUND);
    }
    boolean status = memberService.verifiedCode(email, authCode);
    if (status) {
      return new ResponseEntity<>(
          Collections.singletonMap("message", "Email verified successfully"),
          HttpStatus.OK);
    } else {
      return new ResponseEntity<>(Collections.singletonMap("message", "Invalid verification code"),
          HttpStatus.BAD_REQUEST);
    }
  }

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: Email verified successfully"),
      @ApiResponse(responseCode = "400", description = "BAD_REQUEST: Invalid email format"),
      @ApiResponse(responseCode = "409", description = "CONFLICT: Email is already in use"),
      @ApiResponse(responseCode = "400", description = "BAD_REQUEST: Invalid verification code")
  })
  @Operation(summary = "이메일 인증 코드 확인 - 회원가입할 때 사용",
      description = "이메일 인증 코드를 확인하여 회원가입을 완료합니다. \n" +
          "요청된 이메일이 유효하지 않거나 해당 이메일이 이미 데이터베이스에 존재하는 경우 각각 `400 Bad Request` 또는 `409 Conflict` 상태 코드와 함께 에러 메시지를 반환합니다. \n"
          +
          "인증 코드가 유효하면 회원가입이 완료되었음을 알리는 메시지를 반환하며, `200 OK` 상태 코드와 함께 반환됩니다. \n" +
          "이외에 다른 사유로 이메일 인증 확인에 실패할 경우 `400 Bad Request` 상태 코드와 `Invalid verification code` 에러 메시지를 반환합니다.")
  @GetMapping("/emails/verifications-signup")
  public ResponseEntity<?> verificationEmailForSignup(@RequestParam("email") String email,
      @RequestParam("code") String authCode) {
    if (!EmailValidator.isValidEmail(email)) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Invalid email format"),
          HttpStatus.BAD_REQUEST);
    }
    if (memberService.getMemberByEmail(email) != null) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Email is already in use"),
          HttpStatus.CONFLICT);
    }
    boolean status = memberService.verifiedCode(email, authCode);
    if (status) {
      return new ResponseEntity<>(
          Collections.singletonMap("message", "Email verified successfully"),
          HttpStatus.OK);
    } else {
      return new ResponseEntity<>(Collections.singletonMap("message", "Invalid verification code"),
          HttpStatus.BAD_REQUEST);
    }
  }

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: Password changed successfully"),
      @ApiResponse(responseCode = "401", description = "UNAUTHORIZED: Invalid token"),
      @ApiResponse(responseCode = "400", description = "BAD_REQUEST: Password change failed")
  })
  @Operation(summary = "비밀번호 수정에서의 비밀번호 바꾸기",
      description = "현재 로그인된 사용자의 비밀번호를 변경합니다. \n" +
          "요청에 포함된 토큰에서 이메일을 추출하고, 해당 이메일에 대해 비밀번호를 수정합니다. \n" +
          "토큰이 유효하지 않은 경우 `401 Unauthorized` 상태 코드와 함께 에러 메시지를 반환합니다. \n" +
          "비밀번호 변경이 성공적으로 처리되면 `200 OK` 상태 코드와 함께 성공 메시지를 반환합니다. \n" +
          "이외에 다른 사유로 비밀번호 변경에 실패할 경우 `400 Bad Request` 상태 코드와 `Password change failed` 에러 메시지를 반환합니다.")
  @PostMapping("/emails/password-token")
  public ResponseEntity<?> modifyPasswordByToken(HttpServletRequest request,
      @RequestParam String password) {
    String email = (String) request.getAttribute("userEmail");
    if (email == null) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Invalid token"),
          HttpStatus.UNAUTHORIZED);
    }
    boolean status = memberService.modifyPassword(email, password);
    if (status) {
      return new ResponseEntity<>(
          Collections.singletonMap("message", "Password changed successfully"), HttpStatus.OK);
    } else {
      return new ResponseEntity<>(Collections.singletonMap("message", "Password change failed"),
          HttpStatus.BAD_REQUEST);
    }
  }

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: Password changed successfully"),
      @ApiResponse(responseCode = "400", description = "BAD_REQUEST: Invalid email format"),
      @ApiResponse(responseCode = "404", description = "NOT_FOUND: Email not found"),
      @ApiResponse(responseCode = "400", description = "BAD_REQUEST: Password change failed")
  })
  @Operation(summary = "비밀번호 찾기에서의 비밀번호 바꾸기",
      description = "비밀번호 찾기를 통해서 사용자의 비밀번호를 변경합니다. \n" +
          "요청에서 이메일을 받고, 해당 이메일에 대해 비밀번호를 수정합니다. \n" +
          "요청된 이메일이 유효하지 않거나 해당 이메일이 데이터베이스에 존재하지 않는 경우 각각 `400 Bad Request` 또는 `404 Not Found` 상태 코드와 함께 에러 메시지를 반환합니다. \n"
          +
          "비밀번호 변경이 성공적으로 처리되면 `200 OK` 상태 코드와 함께 성공 메시지를 반환합니다. \n" +
          "이외에 다른 사유로 비밀번호 변경에 실패할 경우 `400 Bad Request` 상태 코드와 `Password change failed` 에러 메시지를 반환합니다.")
  @PostMapping("/emails/password-email")
  public ResponseEntity<?> modifyPasswordByEmail(@RequestParam("email") String email,
      @RequestParam("password") String password) {
    if (!EmailValidator.isValidEmail(email)) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Invalid email format"),
          HttpStatus.BAD_REQUEST);
    }
    if (memberService.getMemberByEmail(email) == null) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Email not found"),
          HttpStatus.NOT_FOUND);
    }
    boolean status = memberService.modifyPassword(email, password);
    if (status) {
      return new ResponseEntity<>(
          Collections.singletonMap("message", "Password changed successfully"), HttpStatus.OK);
    } else {
      return new ResponseEntity<>(Collections.singletonMap("message", "Password change failed"),
          HttpStatus.BAD_REQUEST);
    }
  }
}