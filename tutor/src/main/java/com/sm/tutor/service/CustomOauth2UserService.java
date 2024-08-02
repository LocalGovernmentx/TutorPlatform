package com.sm.tutor.service;


import com.sm.tutor.domain.Member;
import com.sm.tutor.domain.Oauth;
import com.sm.tutor.domain.dto.CustomOauth2UserDetails;
import com.sm.tutor.domain.dto.FacebookUserDetails;
import com.sm.tutor.domain.dto.GoogleUserDetails;
import com.sm.tutor.domain.dto.KakaoUserDetails;
import com.sm.tutor.domain.dto.NaverUserDetails;
import com.sm.tutor.domain.dto.OAuth2UserInfo;
import com.sm.tutor.repository.MemberRepository;
import com.sm.tutor.repository.OauthRepository;
import java.time.Instant;
import java.time.LocalDate;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

@Service
//@RequiredArgsConstructor
@Slf4j
public class CustomOauth2UserService extends DefaultOAuth2UserService {

  private final MemberRepository memberRepository;
  private final OauthRepository oauthRepository;

  @Autowired
  public CustomOauth2UserService(MemberRepository memberRepository,
      OauthRepository oauthRepository) {
    this.memberRepository = memberRepository;
    this.oauthRepository = oauthRepository;
  }

  @Override
  public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
    OAuth2User oAuth2User = super.loadUser(userRequest);
    log.info("getAttributes : {}", oAuth2User.getAttributes());

    String provider = userRequest.getClientRegistration().getRegistrationId();

    OAuth2UserInfo oAuth2UserInfo = null;

    if (provider.equals("google")) {
      log.info("구글 로그인");
      oAuth2UserInfo = new GoogleUserDetails(oAuth2User.getAttributes());
    } else if (provider.equals("kakao")) {
      log.info("카카오 로그인");
      oAuth2UserInfo = new KakaoUserDetails(oAuth2User.getAttributes());
    } else if (provider.equals("naver")) {
      log.info("네이버 로그인");
      oAuth2UserInfo = new NaverUserDetails(oAuth2User.getAttributes());
    } else if (provider.equals("facebook")) {
      log.info("페이스북 로그인");
      oAuth2UserInfo = new FacebookUserDetails(oAuth2User.getAttributes());
    }

    String providerId = oAuth2UserInfo.getProviderId();
    // String email = oAuth2UserInfo.getEmail();
    String email = provider + "_" + providerId;
    String name = oAuth2UserInfo.getName();

    Member findMember = memberRepository.findByEmail(email);
    Member member;
    Oauth oauth;

    if (findMember == null) {
      member = Member.builder()
          .email(email)
          .password("password")
          .phoneNumber("phoneNumber")
          .name(name)
          .nickname("nickname")
          .gender(1)
          .birth(LocalDate.now())
          .verifiedOauth(false)
          .lastlogin(Instant.now())
          .type(1)
          .inviteCode("inviteCode")
          .build();
      memberRepository.save(member);
      oauth = Oauth.builder()
          .member(member)
          .provider(provider)
          .providerId(providerId)
          .build();
      oauthRepository.save(oauth);
    } else {
      member = findMember;
      oauth = oauthRepository.findByProviderId(providerId);
    }

    return new CustomOauth2UserDetails(member, oauth, oAuth2User.getAttributes());
  }
}
