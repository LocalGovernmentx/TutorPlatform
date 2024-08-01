package com.sm.tutor.domain.dto;


import java.util.Map;
import lombok.AllArgsConstructor;

@AllArgsConstructor
public class FacebookUserDetails implements OAuth2UserInfo {

  private Map<String, Object> attributes;
  
  @Override
  public String getProvider() {
    return "facebook";
  }

  @Override
  public String getProviderId() {
    return (String) attributes.get("id");
  }

  @Override
  public String getEmail() {
    return (String) attributes.get("email");
  }

  @Override
  public String getName() {
    return (String) attributes.get("name");
  }
}

