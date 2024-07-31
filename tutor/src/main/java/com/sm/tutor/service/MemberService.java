package com.sm.tutor.service;

import com.sm.tutor.domain.Member;
import com.sm.tutor.repository.MemberRepository;
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
//@RequiredArgsConstructor
public class MemberService {

  private final MemberRepository memberRepository;

  @Autowired
  public MemberService(MemberRepository memberRepository) {
    this.memberRepository = memberRepository;
  }

  public List<Member> getAllMembers() {
    return memberRepository.findAll();
  }

  public Member getMemberById(Long id) {
    Optional<Member> member = memberRepository.findById(id);
    return member.orElse(null);
  }

  public Member saveMember(Member member) {
    return memberRepository.save(member);
  }

  public void deleteMember(Long id) {
    memberRepository.deleteById(id);
  }

  public Member getLoginMemberById(Long memberId) {
    if (memberId == null) {
      return null;
    }

    Optional<Member> findMember = memberRepository.findById(memberId);
    return findMember.orElse(null);

  }

  public Member getLoginMemberByEmail(String email) {
    if (email == null) {
      return null;
    }

    return memberRepository.findByEmail(email);

  }

}
