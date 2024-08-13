package com.sm.tutor.controller;


import com.sm.tutor.service.MemberService;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.util.UriComponentsBuilder;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/oauth")
public class OauthLoginController {

  private final MemberService memberService;

  @Value("${spring.security.oauth2.client.registration.kakao.client-id}")
  private String kakao_client_id;

  @Value("${spring.security.oauth2.client.registration.kakao.redirect-uri}")
  private String kakao_redirect_uri;

  @Value("${spring.security.oauth2.client.registration.kakao.scope}")
  private String kakao_scope;

  @Value("${spring.security.oauth2.client.registration.naver.client-id}")
  private String naver_client_id;

  @Value("${spring.security.oauth2.client.registration.naver.redirect-uri}")
  private String naver_redirect_uri;

  @Value("${spring.security.oauth2.client.registration.naver.scope}")
  private String naver_scope;

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

  @GetMapping("/kakao")
  public ResponseEntity<Void> redirectAuthCodeRequestUrlForKakao(
      HttpServletResponse response
  ) {
    String redirectUrl = UriComponentsBuilder
        .fromUriString("http://localhost:8080/oauth2/authorization/kakao")
        .queryParam("response_type", "code")
        .queryParam("client_id", kakao_client_id)
        .queryParam("redirect_uri", kakao_redirect_uri)
        .queryParam("scope", kakao_scope)
        .build().toUriString();
    try {
      response.sendRedirect(redirectUrl);
    } catch (IOException e) {
      log.info(e.toString());
      throw new RuntimeException(e);
    }
    return ResponseEntity.ok().build();
  }

  @GetMapping("/naver")
  public ResponseEntity<Void> redirectAuthCodeRequestUrlForNaver(
      HttpServletResponse response
  ) {
    String redirectUrl = UriComponentsBuilder
        .fromUriString("http://localhost:8080/oauth2/authorization/naver")
        .queryParam("response_type", "code")
        .queryParam("client_id", naver_client_id)
        .queryParam("redirect_uri", naver_redirect_uri)
        .queryParam("scope", naver_scope)
        .build().toUriString();
    try {
      response.sendRedirect(redirectUrl);
    } catch (IOException e) {
      log.info(e.toString());
      throw new RuntimeException(e);
    }
    return ResponseEntity.ok().build();
  }
}
