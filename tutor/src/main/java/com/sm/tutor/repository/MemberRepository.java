package com.sm.tutor.repository;

import com.sm.tutor.domain.Member;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MemberRepository extends JpaRepository<Member, Long> {

  boolean existsByEmail(String email);

  Member findByEmail(String email);
}
