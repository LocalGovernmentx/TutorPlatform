package com.sm.tutor.controller;


import com.sm.tutor.service.MemberService;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/oauth")
public class OauthLoginController {

  private final MemberService memberService;

  @GetMapping("/info")
  public String oauthInfo(Authentication authentication) {
    OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();
    Map<String, Object> attributes = oAuth2User.getAttributes();
    return attributes.toString();
  }

  // oauth Login이 잘 돌아가는지 확인
  @GetMapping("/loginInfo")
  public ResponseEntity<?> oauthLoginInfo(Authentication authentication) {
    OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();
    Map<String, Object> attributes = oAuth2User.getAttributes();

    return ResponseEntity.status(HttpStatus.OK)
        .body(attributes);
  }
}
