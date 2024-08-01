package com.sm.tutor.config;

import com.sm.tutor.handler.Oauth2SuccessHandler;
import com.sm.tutor.service.CustomOauth2UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

  private final CustomOauth2UserService customOauth2UserService;
  private final Oauth2SuccessHandler oauth2SuccessHandler;

  public WebSecurityCustomizer webSecurityCustomizer() { // security를 적용하지 않을 리소스
    return web -> web.ignoring()
        // error endpoint를 열어줘야 함, favicon.ico 추가!
        .requestMatchers("/error", "/favicon.ico");
  }

  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    // ========= oauth login =========== //
    http
        .authorizeHttpRequests((auth) -> auth
            .requestMatchers("/oauth-login/info").authenticated()
            .anyRequest().permitAll()
        );

    http
        .formLogin((auth) -> auth.disable());
        /*.formLogin((auth) -> auth.loginPage("/oauth-login/login")
        .loginProcessingUrl("/oauth-login/loginProc")
            .usernameParameter("loginId")
            .passwordParameter("password")
            //.defaultSuccessUrl("/oauth-login")
            .defaultSuccessUrl("/oauth/info")
            .failureUrl("/oauth-login")
            .permitAll());*/

    http
        .oauth2Login((auth) ->
            auth.userInfoEndpoint(c -> c.userService(customOauth2UserService))
                //auth.loginPage("/oauth-login/login")
                //.defaultSuccessUrl("/oauth-login")
                .successHandler(oauth2SuccessHandler)
                .defaultSuccessUrl("/oauth/loginInfo")
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
