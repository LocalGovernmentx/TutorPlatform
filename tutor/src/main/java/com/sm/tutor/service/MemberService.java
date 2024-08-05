package com.sm.tutor.service;

import com.sm.tutor.domain.Member;
import com.sm.tutor.repository.MemberRepository;
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
//@RequiredArgsConstructor
public class MemberService {

  private final MemberRepository memberRepository;
  private final PasswordEncoder passwordEncoder; //

  @Autowired
  public MemberService(MemberRepository memberRepository, PasswordEncoder passwordEncoder) {
    this.memberRepository = memberRepository;
    this.passwordEncoder = passwordEncoder;
  }

  public List<Member> getAllMembers() {
    return memberRepository.findAll();
  }

  public Member getMemberById(Long id) {
    Optional<Member> member = memberRepository.findById(id);
    return member.orElse(null);
  }

  public Member saveMember(Member member) {
    String encodedPassword = passwordEncoder.encode(member.getPassword()); // 비밀번호 암호화
    member.setPassword(encodedPassword);
    return memberRepository.save(member);
  }

  public void deleteMember(Long id) {
    memberRepository.deleteById(id);
  }

  public Member getLoginMemberByEmail(String email) {
    if (email == null) {
      return null;
    }
    System.out.println(email);
    return memberRepository.findByEmail(email);
  }

  public boolean authenticateMember(String email, String rawPassword) {
    Member member = getLoginMemberByEmail(email);
    System.out.println(member.toString());
    if (member != null) {
      return passwordEncoder.matches(rawPassword, member.getPassword());
    }
    return false;
  }

}
