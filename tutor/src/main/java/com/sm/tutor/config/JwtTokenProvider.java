package com.sm.tutor.config;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

@Component
public class JwtTokenProvider {

    @Value("${spring.jwt.secret}")
    private String secretKey;

    @Value("${spring.jwt.access-token-validity}")
    private long accessTokenValidity;

    @Value("${spring.jwt.refresh-token-validity}")
    private long refreshTokenValidity;

    private final StringRedisTemplate redisTemplate;

    public JwtTokenProvider(StringRedisTemplate redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    public String createAccessToken(String userId) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + accessTokenValidity);

        return Jwts.builder()
                .setSubject(userId)
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(SignatureAlgorithm.HS256, secretKey)
                .compact();
    }

    public String createRefreshToken(String userId) {
        String refreshToken = UUID.randomUUID().toString();
        redisTemplate.opsForValue().set(userId, refreshToken, refreshTokenValidity, TimeUnit.MILLISECONDS);
        return refreshToken;
    }

    public boolean validateRefreshToken(String userId, String refreshToken) {
        String storedToken = redisTemplate.opsForValue().get(userId);
        return refreshToken.equals(storedToken);
    }

    public void deleteRefreshToken(String userId) {
        redisTemplate.delete(userId);
    }

    private JwtParser getJwtParser() {
        return Jwts.parserBuilder()
                .setSigningKey(secretKey)
                .build();
    }

    public Claims getClaims(String token) {
        return getJwtParser()
                .parseClaimsJws(token)
                .getBody();
    }

    public String getUserId(String token) {
        return getClaims(token).getSubject();
    }

    public boolean isTokenExpired(String token) {
        Date expiration = getClaims(token).getExpiration();
        return expiration.before(new Date());
    }

    public boolean validateToken(String token) {
        try {
            getJwtParser().parseClaimsJws(token);
            return true;
        } catch (Exception e) {
            // Log the exception (optional)
            return false;
        }
    }

    public String resolveToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }

    public Authentication getAuthentication(String token) {
        String userId = getUserId(token);
        return new UsernamePasswordAuthenticationToken(userId, null, null);
    }
}
