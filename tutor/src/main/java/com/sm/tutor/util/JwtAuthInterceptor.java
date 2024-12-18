package com.sm.tutor.util;

import com.sm.tutor.config.JwtTokenProvider;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class JwtAuthInterceptor implements HandlerInterceptor {

    private final JwtTokenProvider tokenProvider;

    public JwtAuthInterceptor(JwtTokenProvider tokenProvider) {
        this.tokenProvider = tokenProvider;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);
            if (tokenProvider.validateToken(token)) {
                String email = tokenProvider.getUserId(token);
                System.out.println(email);
                request.setAttribute("userEmail", email); // 사용자 이메일 저장
                return true;
            }
        }
        response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid or missing token");
        return false;
    }
}