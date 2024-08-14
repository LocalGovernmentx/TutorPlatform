package com.sm.tutor.controller;


import com.sm.tutor.config.JwtTokenProvider;
import com.sm.tutor.service.GoogleService;
import com.sm.tutor.service.KakaoService;
import com.sm.tutor.service.MemberService;
import com.sm.tutor.service.NaverService;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.util.UriComponentsBuilder;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/oauth")
public class OauthLoginController {

  private final MemberService memberService;

  private final KakaoService kakaoService;

  private final NaverService naverService;

  private final GoogleService googleService;

  private final JwtTokenProvider tokenProvider;

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

  /*
  uri: https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=af8af456105a69a0e391ffc86890af47&redirect_uri=http://localhost:8080/oauth/kakao/mobile
  로 접속시, 해당 주소로 redirect
  */
  @GetMapping("/kakao/mobile")
  public ResponseEntity<?> kakaoSignIn(@RequestParam("code") String code) { // 인가코드
    Map<String, Object> result = kakaoService.execKakaoLogin(code);
    if (result.get("email") != null) {
      String accessToken = tokenProvider.createAccessToken(String.valueOf(result.get("email")));
      String refreshToken = tokenProvider.createRefreshToken(
          String.valueOf(result.get("email")));
      Map<String, String> response = new HashMap<>();
      response.put("accessToken", "Bearer " + accessToken);
      response.put("refreshToken", refreshToken);
      return new ResponseEntity<>(response, HttpStatus.OK);
    }
    return new ResponseEntity<>(Collections.singletonMap("message", "Member not found"),
        HttpStatus.NOT_FOUND);
  }

  /*
  uri: https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=AhwyCbYfeYAcdjVkm3ZU&redirect_uri=http://localhost:8080/oauth/naver/mobile
  로 접속시, 해당 주소로 redirect
  */
  @GetMapping("/naver/mobile")
  public ResponseEntity<?> naverSignIn(@RequestParam("code") String code) { // 인가코드
    Map<String, Object> result = naverService.execNaverLogin(code);
    if (result.get("email") != null) {
      String accessToken = tokenProvider.createAccessToken(String.valueOf(result.get("email")));
      String refreshToken = tokenProvider.createRefreshToken(
          String.valueOf(result.get("email")));
      Map<String, String> response = new HashMap<>();
      response.put("accessToken", "Bearer " + accessToken);
      response.put("refreshToken", refreshToken);
      return new ResponseEntity<>(response, HttpStatus.OK);
    }
    return new ResponseEntity<>(Collections.singletonMap("message", "Member not found"),
        HttpStatus.NOT_FOUND);
  }

  /*
  uri: https://accounts.google.com/o/oauth2/auth?client_id=770120720911-0l34151n4bu7ro48pdr6b3ecd1qkkmt5.apps.googleusercontent.com&redirect_uri=http://localhost:8080/oauth/google/mobile&response_type=code&scope=email,profile&access_type=offline
  로 접속시, 해당 주소로 redirect
  */
  @GetMapping("/google/mobile")
  public ResponseEntity<?> googleSignIn(@RequestParam("code") String code) { // 인가코드
    Map<String, Object> result = googleService.execGoogleLogin(code);
    if (result.get("email") != null) {
      String accessToken = tokenProvider.createAccessToken(String.valueOf(result.get("email")));
      String refreshToken = tokenProvider.createRefreshToken(
          String.valueOf(result.get("email")));
      Map<String, String> response = new HashMap<>();
      response.put("accessToken", "Bearer " + accessToken);
      response.put("refreshToken", refreshToken);
      return new ResponseEntity<>(response, HttpStatus.OK);
    }
    return new ResponseEntity<>(Collections.singletonMap("message", "Member not found"),
        HttpStatus.NOT_FOUND);
  }

}
