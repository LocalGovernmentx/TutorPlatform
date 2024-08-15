package com.sm.tutor.controller;

import com.sm.tutor.domain.Member;
import com.sm.tutor.service.MemberService;
import com.sm.tutor.service.S3Service;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.io.InputStream;
import java.util.Collections;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/images")
public class ImageController {

  @Autowired
  private S3Service s3Service;
  @Autowired
  private MemberService memberService;

  @PostMapping(value = "/member", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
  public ResponseEntity<?> uploadImage(@RequestParam("file") MultipartFile file,
      HttpServletRequest request) {
    String email = (String) request.getAttribute("userEmail");
    if (email == null) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Invalid token"),
          HttpStatus.UNAUTHORIZED);
    }

    if (file.isEmpty()) {
      return new ResponseEntity<>(Collections.singletonMap("message", "No file selected"),
          HttpStatus.BAD_REQUEST);
    }

    try (InputStream inputStream = file.getInputStream()) {
      String fileName = System.currentTimeMillis() + "-" + file.getOriginalFilename();
      // 프로필 사진 저장 경로
      String folderPath = "uploads/profiles/" + email + "/";
      String filePath = folderPath + fileName;

      // S3에 파일 업로드
      String imageUrl = s3Service.uploadFile(filePath, inputStream, file.getSize());

      // Member 엔티티 업데이트
      Member member = memberService.getMemberByEmail(email);
      if (member != null) {
        member.setImage(imageUrl); // URL을 Member 엔티티에 저장
        memberService.modifyMemberInfo(member);
        return new ResponseEntity<>(Collections.singletonMap("message", "File uploaded successfully"), HttpStatus.OK);
      } else {
        return new ResponseEntity<>(Collections.singletonMap("message", "Member not found"),
            HttpStatus.NOT_FOUND);
      }
    } catch (IOException e) {
      return new ResponseEntity<>(Collections.singletonMap("message", "File upload failed"),
          HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }
}
