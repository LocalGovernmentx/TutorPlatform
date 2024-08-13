package com.sm.tutor.handler;

import com.sm.tutor.config.JwtTokenProvider;
import com.sm.tutor.domain.dto.CustomOauth2UserDetails;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.util.UriComponentsBuilder;

@RequiredArgsConstructor
@Component
@Slf4j
public class OAuth2AuthenticationSuccessHandler implements AuthenticationSuccessHandler {

  // 성공시 토큰 발급 및 응답
  private final JwtTokenProvider jwtTokenProvider;
  private static final String URI = "/";

  @Override
  public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
      Authentication authentication) throws IOException, ServletException {
    Object principal = authentication.getPrincipal();
    CustomOauth2UserDetails details = null;

    if (principal instanceof CustomOauth2UserDetails) {
      details = (CustomOauth2UserDetails) principal;
    }

    if (details == null) {
      String redirectUrl = UriComponentsBuilder.fromUriString(URI)
          .queryParam("error", "Login failed")
          .build().toUriString();

      response.sendRedirect(redirectUrl);
      return;
    }

    // accessToken, refreshToken 발급
    String accessToken = jwtTokenProvider.createAccessToken(
        details.getUsername());
    String refreshToken = jwtTokenProvider.createRefreshToken(
        details.getUsername());

    log.info("token: {}", accessToken + " " + refreshToken);
    // 토큰 전달을 위한 redirect
    String redirectUrl = UriComponentsBuilder.fromUriString(URI)
        .queryParam("accessToken", "Bearer " + accessToken)
        .queryParam("refreshToken", refreshToken)
        .build().toUriString();

    //response.sendRedirect(redirectUrl);
  }
}