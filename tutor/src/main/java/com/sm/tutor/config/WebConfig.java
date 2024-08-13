package com.sm.tutor.config;

import com.sm.tutor.util.JwtAuthInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

  @Autowired
  private JwtAuthInterceptor jwtAuthInterceptor;

  @Override
  public void addInterceptors(InterceptorRegistry registry) {
    registry.addInterceptor(jwtAuthInterceptor)
        .addPathPatterns("/api/members/**", "api/lectures/**")
        .excludePathPatterns("/api/members/login",
            "/api/members",
            "/api/members/check-email",
            "/api/members/check-nickname",
            "/api/members/emails/verification-requests",
            "/api/members/emails/verifications",
            "/api/members/emails/verifications-signup");
  }
}

