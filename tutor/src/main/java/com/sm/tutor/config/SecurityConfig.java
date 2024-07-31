package com.sm.tutor.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    // ========= oauth login =========== //
    http
        .authorizeHttpRequests((auth) -> auth
            .requestMatchers("/oauth-login/info").authenticated()
            .anyRequest().permitAll()
        );

    http
        .formLogin((auth) -> auth.loginPage("/oauth-login/login")
            .loginProcessingUrl("/oauth-login/loginProc")
            .usernameParameter("loginId")
            .passwordParameter("password")
            .defaultSuccessUrl("/oauth-login")
            .failureUrl("/oauth-login")
            .permitAll());

    http
        .oauth2Login((auth) -> auth.loginPage("/oauth-login/login")
            .defaultSuccessUrl("/oauth-login")
            .failureUrl("/oauth-login/login")
            .permitAll());

    http
        .logout((auth) -> auth
            .logoutUrl("/oauth-login/logout"));

    http
        .csrf((auth) -> auth.disable());

    return http.build();
  }
}
