package com.sm.tutor.config;

import com.sm.tutor.handler.Oauth2SuccessHandler;
import com.sm.tutor.service.CustomOauth2UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

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
  public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
  }

  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

    // 폼 로그인 설정 추가
    http.
        authorizeHttpRequests(auth -> auth
            .requestMatchers("/api/members/login").permitAll()
            .requestMatchers("/api/members/logout").permitAll()
            .requestMatchers("/oauth-login/info").authenticated()
            .requestMatchers("/home").authenticated()
            .anyRequest().permitAll()
        )
        .formLogin(formLogin -> formLogin
            .loginPage("/api/members/login")
            .loginProcessingUrl("/api/members/login")
            .usernameParameter("email")
            .passwordParameter("password")
            .defaultSuccessUrl("/home", true)
            .failureUrl("/login?error=true")
            .permitAll()
        )
        // 로그아웃 설정
        .logout(logout -> logout
            .logoutUrl("/api/member/logout") // 로그아웃 URL
            .logoutSuccessUrl("/login?logout=true") // 로그아웃 후 리다이렉트 URL
            .permitAll()
        );

    // ========= oauth login =========== //
//    http
//        .authorizeHttpRequests((auth) -> auth
//            .requestMatchers("/oauth-login/info").authenticated()
//            .anyRequest().permitAll()
//        );

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

  // CORS 설정 빈 추가
  @Bean
  public WebMvcConfigurer corsConfigurer() {
    return new WebMvcConfigurer() {
      @Override
      public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
            .allowedOrigins("https://www.modututor.com") // Swagger UI가 호스팅되는 도메인
            .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
            .allowedHeaders("*")
            .allowCredentials(true);
      }
    };
  }
}
