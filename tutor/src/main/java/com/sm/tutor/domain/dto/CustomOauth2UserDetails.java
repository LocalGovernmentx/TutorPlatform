package com.sm.tutor.domain.dto;

import com.sm.tutor.domain.Member;
import com.sm.tutor.domain.Oauth;
import java.util.Collection;
import java.util.Map;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.core.user.OAuth2User;

public class CustomOauth2UserDetails implements UserDetails, OAuth2User {

  private final Member member;
  private final Oauth oauth;
  private Map<String, Object> attributes;

  public CustomOauth2UserDetails(Member member, Oauth oauth, Map<String, Object> attributes) {
    this.oauth = oauth;
    this.member = member;
    this.attributes = attributes;
  }


  @Override
  public Map<String, Object> getAttributes() {
    return attributes;
  }

  @Override
  public String getName() {
    return null;
  }

  @Override
  public Collection<? extends GrantedAuthority> getAuthorities() {
    Collection<GrantedAuthority> collection = AuthorityUtils.createAuthorityList("ROLE_USER");
    return collection;
  }

  @Override
  public String getPassword() {
    return member.getPassword();
  }

  @Override
  public String getUsername() {
    return member.getEmail();
  }

  @Override
  public boolean isAccountNonExpired() {
    return true;
  }

  @Override
  public boolean isAccountNonLocked() {
    return true;
  }

  @Override
  public boolean isCredentialsNonExpired() {
    return true;
  }

  @Override
  public boolean isEnabled() {
    return true;
  }

}