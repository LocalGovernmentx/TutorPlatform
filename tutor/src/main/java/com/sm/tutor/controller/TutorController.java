package com.sm.tutor.controller;

import com.sm.tutor.domain.Member;
import com.sm.tutor.service.MemberService;
import com.sm.tutor.service.TutorService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Collections;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/tutor")
public class TutorController {

  @Autowired
  private MemberService memberService;
  @Autowired
  private TutorService tutorService;

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: 성공", content = {
          @Content(schema = @Schema(implementation = Member.class))}),
      @ApiResponse(responseCode = "404", description = "NOT_FOUND: Member not found")
  })
  @Operation(summary = "튜터 등록하기")
  @PostMapping()
  public ResponseEntity<?> registerTutor(HttpServletRequest request,
      @RequestParam String introduction, @RequestParam String job) {
    String email = (String) request.getAttribute("userEmail");
    Member member = memberService.getMemberByEmail(email);
    if (member != null) {
      member.setType(2);
      tutorService.registerTutor(member, job, introduction);
      memberService.modifyMemberInfo(member);
      return new ResponseEntity<>(member, HttpStatus.OK);
    } else {
      return new ResponseEntity<>(Collections.singletonMap("message", "Member not found"),
          HttpStatus.NOT_FOUND);
    }
  }

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: 성공"),
      @ApiResponse(responseCode = "404", description = "NOT_FOUND: Member not found")
  })
  @Operation(summary = "타입 조회하기")
  @GetMapping()
  public ResponseEntity<?> getMyType(HttpServletRequest request) {
    String email = (String) request.getAttribute("userEmail");
    Member member = memberService.getMemberByEmail(email);
    if (member != null) {
      return new ResponseEntity<>(member.getType(), HttpStatus.OK);
    } else {
      return new ResponseEntity<>(Collections.singletonMap("message", "Member not found"),
          HttpStatus.NOT_FOUND);
    }
  }
}
