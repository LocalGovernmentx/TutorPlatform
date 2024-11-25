package com.sm.tutor.handler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.util.UriComponentsBuilder;

@RequiredArgsConstructor
@Component
@Slf4j
public class OAuth2AuthenticationFailureHandler implements AuthenticationFailureHandler {

  private static final String URI = "/";

  @Override
  public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
      AuthenticationException exception) throws IOException {

    log.info("exception: {}", exception.getLocalizedMessage());
    // 실패 전달을 위한 redirect
    String redirectUrl = UriComponentsBuilder.fromUriString(URI)
        .queryParam("error", exception.getLocalizedMessage().toString())
        .build().toUriString();

    response.sendRedirect(redirectUrl);
  }
}
