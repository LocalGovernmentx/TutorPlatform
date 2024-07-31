package com.sm.tutor.repository;

import com.sm.tutor.domain.Oauth;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OauthRepository extends JpaRepository<Oauth, Long> {

  Oauth findByMemberId(Integer memberId);

  Oauth findByProviderId(String providerId);
}
