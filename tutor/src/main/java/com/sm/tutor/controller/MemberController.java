package com.sm.tutor.controller;

import com.sm.tutor.domain.Member;
import com.sm.tutor.service.MemberService;
import io.swagger.v3.oas.annotations.Operation;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
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
  private MemberService memberService;

  @Operation(summary = "모든 멤버 조회", description = "개발용")
  @GetMapping
  public ResponseEntity<List<Member>> getAllMembers() {
    List<Member> members = memberService.getAllMembers();
    return new ResponseEntity<>(members, HttpStatus.OK);
  }

  @GetMapping("/{id}")
  @Operation(summary = "내 정보 조회")
  public ResponseEntity<Member> getMemberById(@PathVariable Long id) {
    Member member = memberService.getMemberById(id);
    return member != null ? new ResponseEntity<>(member, HttpStatus.OK) :
        new ResponseEntity<>(HttpStatus.NOT_FOUND);
  }

  @Operation(summary = "회원가입")
  @PostMapping
  public ResponseEntity<Member> createMember(@RequestBody Member member) {
    Member createdMember = memberService.saveMember(member);
    return new ResponseEntity<>(createdMember, HttpStatus.CREATED);
  }

  @Operation(summary = "회원탈퇴")
  @DeleteMapping("/{id}")
  public ResponseEntity<Void> deleteMember(@PathVariable Long id) {
    memberService.deleteMember(id);
    return new ResponseEntity<>(HttpStatus.NO_CONTENT);
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