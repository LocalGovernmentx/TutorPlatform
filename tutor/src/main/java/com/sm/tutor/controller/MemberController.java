package com.sm.tutor.controller;

import com.sm.tutor.config.JwtTokenProvider;
import com.sm.tutor.domain.Member;
import com.sm.tutor.service.MemberService;
import io.swagger.v3.oas.annotations.Operation;
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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/members")
public class MemberController {

  @Autowired
  private MemberService memberService;
  @Autowired
  private PasswordEncoder passwordEncoder;
  @Autowired
  private final JwtTokenProvider tokenProvider;

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
                  + "여기에는 아무 값이나 넣기\n"
                  + "Header에 토큰 값 넣어서 요청하면 됨"
  )
  @GetMapping("/me")
  public ResponseEntity<Member> getMyInfo(@RequestHeader("Authorization") String authHeader) {
    // Authorization 헤더에서 Bearer 토큰 추출
    String token = authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;
    System.out.println(token);
    if (tokenProvider.validateToken(token)) {
      String email = tokenProvider.getUserId(token);
      Member member = memberService.getMemberByEmail(email);
      return member != null ? new ResponseEntity<>(member, HttpStatus.OK) :
              new ResponseEntity<>(HttpStatus.NOT_FOUND);
    } else {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }
  }

  @Operation(summary = "회원가입")
  @PostMapping
  public ResponseEntity<Member> createMember(@RequestBody Member member) {
    Member createdMember = memberService.saveMember(member);
    return new ResponseEntity<>(createdMember, HttpStatus.CREATED);
  }

  @Operation(summary = "회원탈퇴")
  @DeleteMapping("/{email}")
  public ResponseEntity<String> deleteMember(@PathVariable String email) {
    memberService.deleteMember(email);
    return new ResponseEntity<>("탈퇴 성공", HttpStatus.OK);
  }

  @Operation(summary = "로그인",
            description = "스웨거 테스트 시 토큰값 오른 쪽 위 authorize에 넣기 Bearer 빼고. 클라이언트에서 요청 보낼때는 Bearer 넣고"  )
  @PostMapping("/login")
  public ResponseEntity<Map<String, String>> login(@RequestParam String email, @RequestParam String password) {
    Member member = memberService.getMemberByEmail(email);
    if (member != null && passwordEncoder.matches(password, member.getPassword())) {
      String accessToken = tokenProvider.createAccessToken(email);
      String refreshToken = tokenProvider.createRefreshToken(email);
      Map<String, String> response = new HashMap<>();
      response.put("accessToken", "Bearer " + accessToken);
      response.put("refreshToken", refreshToken);
      return new ResponseEntity<>(response, HttpStatus.OK);
    } else {
      return new ResponseEntity<>(Collections.singletonMap("message", "로그인 실패"), HttpStatus.UNAUTHORIZED);
    }
  }


  @Operation(summary = "로그아웃")
  @PostMapping("/logout")
  public ResponseEntity<String> logout(@RequestParam String userId) {
    tokenProvider.deleteRefreshToken(userId);
    return new ResponseEntity<>("로그아웃 성공", HttpStatus.OK);
  }

  @Operation(summary = "리프레시 토큰으로 액세스 토큰 재발급")
  @PostMapping("/refresh")
  public ResponseEntity<String> refreshToken(@RequestParam String userId, @RequestParam String refreshToken) {
    if (tokenProvider.validateRefreshToken(userId, refreshToken)) {
      String newAccessToken = tokenProvider.createAccessToken(userId);
      return new ResponseEntity<>(newAccessToken, HttpStatus.OK);
    } else {
      return new ResponseEntity<>("유효하지 않은 리프레시 토큰", HttpStatus.UNAUTHORIZED);
    }
  }

  @Operation(summary = "이메일 인증 코드 전송 요청")
  @PostMapping("/emails/verification-requests")
  public ResponseEntity<Void> sendMessage(@RequestParam("email") String email) {
    memberService.sendCodeToEmail(email);

    return new ResponseEntity<>(HttpStatus.OK);
  }

  @Operation(summary = "이메일 인증 코드 확인")
  @GetMapping("/emails/verifications")
  public ResponseEntity<Boolean> verificationEmail(@RequestParam("email") String email,
      @RequestParam("code") String authCode) {
    boolean status = memberService.verifiedCode(email, authCode);

    return new ResponseEntity<>(status, HttpStatus.OK);
  }

  @Operation(summary = "비밀번호 바꾸기")
  @PostMapping("/emails/password")
  public ResponseEntity<Boolean> modifyPassword(@RequestParam("email") String email,
      @RequestParam String password) {
    boolean status = memberService.modifyPassword(email, password);

    return new ResponseEntity<>(status, HttpStatus.OK);
  }
}