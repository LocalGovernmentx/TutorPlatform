package com.sm.tutor.service;

import com.sm.tutor.domain.Member;
import com.sm.tutor.repository.MemberRepository;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.Duration;
import java.util.List;
import java.util.Optional;
import java.util.Random;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@Transactional
//@RequiredArgsConstructor
public class MemberService {

  private final MemberRepository memberRepository;
  private final PasswordEncoder passwordEncoder; //

  private static final String AUTH_CODE_PREFIX = "AuthCode ";

  private final EmailService emailService;

  private final RedisService redisService;

  @Value("${spring.mail.auth-code-expiration-millis}")
  private long authCodeExpirationMillis;

  public MemberService(MemberRepository memberRepository, PasswordEncoder passwordEncoder,
      EmailService emailService,
      RedisService redisService) {
    this.memberRepository = memberRepository;
    this.passwordEncoder = passwordEncoder;
    this.emailService = emailService;
    this.redisService = redisService;
  }

  public List<Member> getAllMembers() {
    return memberRepository.findAll();
  }

  public Member getMemberByEmail(String email) {
    Optional<Member> member = memberRepository.findByEmail(email);
    return member.orElse(null);
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

  public void deleteMember(String email) {
    memberRepository.deleteById(Long.valueOf(getMemberByEmail(email).getId()));
  }

  public void sendCodeToEmail(String toEmail) {
    // this.checkDuplicatedEmail(toEmail);
    String title = "TutorPlatform 이메일 인증 번호";
    String authCode = this.createCode();
    emailService.sendEmail(toEmail, title, authCode);
    // 이메일 인증 요청 시 인증 번호 Redis 에 저장 ( key = "AuthCode " + Email / value = AuthCode )
    redisService.setValues(AUTH_CODE_PREFIX + toEmail,
        authCode, Duration.ofMillis(this.authCodeExpirationMillis));
  }

  private boolean checkDuplicatedEmail(String email) {
    Optional<Member> member = memberRepository.findByEmail(email);
    return member.isEmpty();
    /*if (member.isPresent()) {
      log.debug("MemberServiceImpl.checkDuplicatedEmail exception occur email: {}", email);
      // throw new RuntimeException(404, "MEMBER_EXISTS");
    }*/
  }

  private String createCode() {
    int length = 6;
    try {
      Random random = SecureRandom.getInstanceStrong();
      StringBuilder builder = new StringBuilder();
      for (int i = 0; i < length; i++) {
        builder.append(random.nextInt(10));
      }
      return builder.toString();
    } catch (NoSuchAlgorithmException e) {
      log.debug("MemberService.createCode() exception occur");
      // throw new RuntimeException(404, "NO_SUCH_ALGORITHM");
    }
    return "000000";
  }

  public boolean verifiedCode(String email, String authCode) {
    // this.checkDuplicatedEmail(email);
    String redisAuthCode = redisService.getValues(AUTH_CODE_PREFIX + email);
    boolean authResult =
        redisService.checkExistsValue(redisAuthCode) && redisAuthCode.equals(authCode);
    if (!authResult) {
      log.debug("MemberService.verifiedCode() exception occur");
      return false;
    } else {
      return true;
    }
  }

  public boolean modifyPassword(String email, String password) {
    Optional<Member> findMember = memberRepository.findByEmail(email);
    //    .orElseThrow(() -> new IllegalArgumentException("No Email Found."));
    if (findMember.isEmpty()) {
      return false;
    }
    String encodedPassword = passwordEncoder.encode(password);
    findMember.orElse(null).setPassword(encodedPassword);

    return true;
  }

  public boolean checkNickname(String nickname) {
    return memberRepository.findByNickname(nickname).isPresent();
  }
}
