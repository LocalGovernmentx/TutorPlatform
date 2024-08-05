package com.sm.tutor.controller;

import com.sm.tutor.domain.Member;
import com.sm.tutor.service.MemberService;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/members")
public class MemberController {

  @Autowired
  private MemberService memberService;
  @Autowired
  private PasswordEncoder passwordEncoder;

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

  @Operation(summary = "로그인")
  @PostMapping("/login")
  public ResponseEntity<String> login(@RequestParam String email, @RequestParam String password) {
    boolean authenticated = memberService.authenticateMember(email, password);
    if (authenticated) {
      // 로그인 성공 시, 실제로는 JWT를 발급하거나 세션을 생성합니다.
      return new ResponseEntity<>("로그인 성공", HttpStatus.OK);
    } else {
      return new ResponseEntity<>("로그인 실패", HttpStatus.UNAUTHORIZED);
    }
  }
}