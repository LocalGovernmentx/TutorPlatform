package com.sm.tutor.handler;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

@RequiredArgsConstructor
@Component
public class Oauth2SuccessHandler implements AuthenticationSuccessHandler {

  /*
  // 성공시 토큰 발급 및 응답
  private final TokenProvider tokenProvider;
  private static final String URI = "/auth/success";

  @Override
  public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
      Authentication authentication) throws IOException, ServletException {
    // accessToken, refreshToken 발급
    String accessToken = tokenProvider.generateAccessToken(authentication);
    tokenProvider.generateRefreshToken(authentication, accessToken);

    // 토큰 전달을 위한 redirect
    String redirectUrl = UriComponentsBuilder.fromUriString(URI)
        .queryParam("accessToken", accessToken)
        .build().toUriString();

    response.sendRedirect(redirectUrl);
  }*/
  public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
      Authentication authentication) throws IOException, ServletException {
  }
}