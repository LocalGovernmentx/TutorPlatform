package com.sm.tutor.repository;

import com.sm.tutor.domain.Oauth;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OauthRepository extends JpaRepository<Oauth, Long> {

  Optional<Oauth> findByMemberId(Integer memberId);

  Optional<Oauth> findByProviderId(String providerId);
}
