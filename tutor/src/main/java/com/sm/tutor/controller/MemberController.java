package com.sm.tutor.controller;

import com.sm.tutor.config.JwtTokenProvider;
import com.sm.tutor.domain.Member;
import com.sm.tutor.service.MemberService;
import com.sm.tutor.util.EmailValidator;
import io.swagger.v3.oas.annotations.Operation;
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

  @Operation(summary = "내 정보 조회",
      description = "오른쪽위 authorize에 토큰값 넣기"
  )
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

  @Operation(summary = "회원가입")
  @PostMapping
  public ResponseEntity<?> createMember(@RequestBody Member member) {
    if (!EmailValidator.isValidEmail(member.getEmail())) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Invalid email format"),
          HttpStatus.BAD_REQUEST);
    }
    if (memberService.checkNickname(member.getNickname())) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Nickname is already in use"),
          HttpStatus.CONFLICT);
    }
    if (memberService.checkPhoneNumber(member.getPhoneNumber())) {
      return new ResponseEntity<>(
          Collections.singletonMap("message", "PhoneNumber is already in use"),
          HttpStatus.CONFLICT);
    }
    // 이메일 인증 여부 확인
    String verificationStatus = memberService.getEmailVerificationStatus(member.getEmail());
    if ("unverified".equals(verificationStatus)) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Email is not verified"),
          HttpStatus.BAD_REQUEST);
    }
    if (memberService.getMemberByEmail(member.getEmail()) != null) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Email is already in use"),
          HttpStatus.CONFLICT);
    }
    Member createdMember = memberService.saveMember(member);
    return new ResponseEntity<>(Collections.singletonMap("message", "Member created successfully"),
        HttpStatus.CREATED);
  }

  @Operation(summary = "이메일 중복확인")
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

  @Operation(summary = "닉네임 중복확인")
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

  @Operation(summary = "회원탈퇴")
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

  @Operation(summary = "로그인")
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


  @Operation(summary = "로그아웃")
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

  @Operation(summary = "리프레시 토큰으로 액세스 토큰 재발급")
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

  @Operation(summary = "이메일 인증 코드 전송 요청")
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

  @Operation(summary = "이메일 인증 코드 확인 - 비밀번호 찾기할 때 사용", description = "성공 return 값: token")
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
      // 일치할 경우 토큰 생성 및 할당
      String accessToken = tokenProvider.createAccessToken(email);
      String refreshToken = tokenProvider.createRefreshToken(email);
      Map<String, String> response = new HashMap<>();
      response.put("accessToken", "Bearer " + accessToken);
      response.put("refreshToken", refreshToken);
      return new ResponseEntity<>(response, HttpStatus.OK);
    } else {
      return new ResponseEntity<>(Collections.singletonMap("message", "Invalid verification code"),
          HttpStatus.BAD_REQUEST);
    }
  }

  @Operation(summary = "이메일 인증 코드 확인 - 회원가입할 때 사용", description = "성공 return 값: message")
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

  @Operation(summary = "비밀번호 바꾸기")
  @PostMapping("/emails/password")
  public ResponseEntity<?> modifyPassword(HttpServletRequest request,
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
}