package com.sm.tutor.config;

import com.sm.tutor.handler.OAuth2AuthenticationFailureHandler;
import com.sm.tutor.handler.OAuth2AuthenticationSuccessHandler;
import com.sm.tutor.service.CustomOauth2UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

  private final CustomOauth2UserService customOauth2UserService;
  private final OAuth2AuthenticationSuccessHandler oauth2AuthenticationSuccessHandler;
  private final OAuth2AuthenticationFailureHandler oAuth2AuthenticationFailureHandler;
  private final JwtTokenProvider tokenProvider;

  @Bean
  public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
  }

  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    JwtAuthenticationFilter jwtAuthenticationFilter = new JwtAuthenticationFilter(tokenProvider);

    http
        .authorizeHttpRequests(auth -> auth
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
        .oauth2Login((auth) ->
                auth.userInfoEndpoint(c -> c.userService(customOauth2UserService))
                    //auth.loginPage("/oauth-login/login")
                    //.defaultSuccessUrl("/oauth-login")
                    .successHandler(oauth2AuthenticationSuccessHandler)
                    .failureHandler(oAuth2AuthenticationFailureHandler)
            //.defaultSuccessUrl("/oauth/loginInfo")
        )
        .logout(logout -> logout
            .logoutUrl("/api/member/logout")
            .logoutSuccessUrl("/login?logout=true")
            .permitAll()
        )
        .csrf(csrf -> csrf.disable())
        .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

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
