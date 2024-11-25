package com.sm.tutor.service;

import com.nimbusds.jose.shaded.gson.JsonElement;
import com.nimbusds.jose.shaded.gson.JsonObject;
import com.nimbusds.jose.shaded.gson.JsonParser;
import com.sm.tutor.domain.Member;
import com.sm.tutor.domain.Oauth;
import com.sm.tutor.repository.MemberRepository;
import com.sm.tutor.repository.OauthRepository;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.Instant;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class NaverService {

  private final OauthRepository oauthRepository;

  private final MemberRepository memberRepository;

  @Value("${spring.security.oauth2.client.registration.naver.authorization-grant-type}")
  private String authorization_grant_type;

  @Value("${spring.security.oauth2.client.registration.naver.redirect-uri}")
  private String redirect_uri;

  @Value("${spring.security.oauth2.client.registration.naver.client-id}")
  private String client_id;

  @Value("${spring.security.oauth2.client.provider.naver.token-uri}")
  private String token_uri;

  @Value("${spring.security.oauth2.client.provider.naver.user-info-uri}")
  private String user_info_uri;

  @Value("${spring.security.oauth2.client.registration.naver.client-secret}")
  private String client_secret;

  public Map<String, Object> execNaverLogin(String authorize_code) {
    log.info("authorize_code: {}", authorize_code);
    String accessToken = getAccessToken(authorize_code);
    Map<String, Object> userInfo = getUserInfo(accessToken);
    log.info("UserInfo: {}", userInfo.toString());

    String providerId = String.valueOf(userInfo.get("providerId"));
    String provider = String.valueOf(userInfo.get("provider"));
    String email = String.valueOf(userInfo.get("email"));
    String nickname = String.valueOf(userInfo.get("nickname"));
    String name = String.valueOf(userInfo.get("name"));
    String phoneNumber = String.valueOf(userInfo.get("phoneNumber"));

    log.info("email: {}", email);

    if (oauthRepository.findByProviderId(providerId).isEmpty()) {

      Member findMember = memberRepository.findByEmail(email).orElse(null);
      Member member;
      Oauth oauth;

      if (findMember == null) {
        member = Member.builder()
            .email(email)
            .password("password")
            .phoneNumber(phoneNumber)
            .name(name)
            .nickname(nickname)
            .gender(1)
            .birth(LocalDate.now())
            .verifiedOauth(true)
            .lastlogin(Instant.now())
            .type(1)
            .inviteCode("inviteCode")
            .image("image.png")
            .build();
        memberRepository.save(member);
        oauth = Oauth.builder()
            .member(member)
            .provider(provider)
            .providerId(providerId)
            .build();
        oauthRepository.save(oauth);
      }
    }

    return userInfo;
  }

  public String getAccessToken(String authorize_code) {
    String accessToken = "";
    String refreshToken = "";
    String reqURL = token_uri;

    try {
      URL url = new URL(reqURL);
      HttpURLConnection conn = (HttpURLConnection) url.openConnection();

      conn.setRequestMethod("POST");
      conn.setDoOutput(true);

      BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
      StringBuilder sb = new StringBuilder();
      sb.append("grant_type=" + authorization_grant_type);
      sb.append("&client_id=" + client_id);
      sb.append("&redirect_uri=" + redirect_uri);
      sb.append("&client_secret=" + client_secret);
      sb.append("&code=" + authorize_code);
      bw.write(sb.toString());
      bw.flush();

      int responseCode = conn.getResponseCode();

      log.info("responseCode: {}", String.valueOf(responseCode));

      BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));

      String line = "";
      String result = "";

      while ((line = br.readLine()) != null) {
        result += line;
      }

      JsonElement element = JsonParser.parseString(result);

      log.info(element.toString());

      accessToken = element.getAsJsonObject().get("access_token").getAsString();
      refreshToken = element.getAsJsonObject().get("refresh_token").getAsString();

      br.close();
      bw.close();
    } catch (IOException e) {
      e.printStackTrace();
    }

    return accessToken;
  }

  public Map<String, Object> getUserInfo(String accessToken) {
    Map<String, Object> userInfo = new HashMap<>();

    String reqURL = user_info_uri;

    try {
      URL url = new URL(reqURL);
      HttpURLConnection conn = (HttpURLConnection) url.openConnection();
      conn.setRequestMethod("GET");

      conn.setRequestProperty("Authorization", "Bearer " + accessToken);

      int responseCode = conn.getResponseCode();

      BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));

      String line = "";
      String result = "";

      while ((line = br.readLine()) != null) {
        result += line;
      }

      JsonElement element = JsonParser.parseString(result);

      JsonObject response = element.getAsJsonObject().get("response").getAsJsonObject();

      String nickname = response.getAsJsonObject().get("nickname").getAsString();
      String id = response.getAsJsonObject().get("id").getAsString();
      String email = response.getAsJsonObject().get("email").getAsString();
      String phoneNumber = response.getAsJsonObject().get("mobile").getAsString();
      String name = response.getAsJsonObject().get("name").getAsString();

      //log.info("properties: {}", properties.getAsJsonObject().toString());
      //log.info("kakao account: {}", kakao_account.getAsJsonObject().toString());
      log.info("id: {}", id);
      log.info("element: {}", element.getAsJsonObject().toString());
      userInfo.put("name", name);
      userInfo.put("nickname", nickname);
      userInfo.put("provider", "NAVER");
      userInfo.put("providerId", id);
      userInfo.put("phoneNumber", phoneNumber);
      userInfo.put("email", email);
    } catch (IOException e) {
      e.printStackTrace();
    }

    return userInfo;
  }

}
