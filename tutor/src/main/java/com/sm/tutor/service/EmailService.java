package com.sm.tutor.service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class EmailService {

  private final JavaMailSender emailSender;

  public void sendEmail(String toEmail,
      String title,
      String text) {
    SimpleMailMessage emailForm = createEmailForm(toEmail, title, text);
    try {
      emailSender.send(emailForm);
    } catch (RuntimeException e) {
      log.debug("EmailService.sendEmail exception occur toEmail: {}, " +
          "title: {}, text: {}", toEmail, title, text);
      // throw new RuntimeException(404, "메일을 전송할 수 없습니다.");
      // exception 호출
    }
  }

  // 발신할 이메일 데이터 세팅
  private SimpleMailMessage createEmailForm(String toEmail,
      String title,
      String text) {
    SimpleMailMessage message = new SimpleMailMessage();
    message.setTo(toEmail);
    message.setSubject(title);
    message.setText(text);

    return message;
  }

}
