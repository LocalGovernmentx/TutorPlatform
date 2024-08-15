package com.sm.tutor.controller;

import com.sm.tutor.domain.Member;
import com.sm.tutor.service.MemberService;
import com.sm.tutor.service.S3Service;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
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

  // 최대 파일 크기: 10MB
  private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
  @Autowired
  private S3Service s3Service;
  @Autowired
  private MemberService memberService;

  @Operation(
      summary = "회원 프로필 이미지 업로드",
      description = "회원의 프로필 이미지를 업로드합니다. 기존 이미지가 있을 경우 삭제하고 새 이미지를 업로드합니다.",
      responses = {
          @ApiResponse(responseCode = "200", description = "파일 업로드 성공"),
          @ApiResponse(responseCode = "400", description = "잘못된 요청 (파일이 없거나, 이미지 파일이 아님, 파일 크기 초과 등)"),
          @ApiResponse(responseCode = "401", description = "인증 실패"),
          @ApiResponse(responseCode = "404", description = "회원 찾을 수 없음"),
          @ApiResponse(responseCode = "500", description = "서버 오류 (파일 업로드 실패 등)")
      }
  )
  @PostMapping(value = "/member", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
  public ResponseEntity<?> uploadImage(@RequestParam("file") MultipartFile file,
      HttpServletRequest request) {

    // 사용자 이메일을 요청 속성에서 가져오기
    String email = (String) request.getAttribute("userEmail");
    if (email == null) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Invalid token"),
          HttpStatus.UNAUTHORIZED);
    }

    // 파일이 비어있는 경우 처리
    if (file.isEmpty()) {
      return new ResponseEntity<>(Collections.singletonMap("message", "No file selected"),
          HttpStatus.BAD_REQUEST);
    }

    // 파일이 이미지인지 확인
    String contentType = file.getContentType();
    if (contentType == null || !contentType.startsWith("image/")) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Invalid file type"),
          HttpStatus.BAD_REQUEST);
    }

    // 파일 크기 제한
    if (file.getSize() > MAX_FILE_SIZE) {
      return new ResponseEntity<>(Collections.singletonMap("message", "File size exceeds limit"),
          HttpStatus.BAD_REQUEST);
    }

    try (InputStream inputStream = file.getInputStream()) {
      // 파일 이름 설정 (이메일 주소 기반)
      String fileName = email + "-profile" + getFileExtension(file.getOriginalFilename());
      String folderPath = "uploads/profiles/";
      String filePath = folderPath + fileName;

      // 현재 프로필 이미지 URL을 멤버에서 가져오기
      Member member = memberService.getMemberByEmail(email);
      if (member == null) {
        return new ResponseEntity<>(Collections.singletonMap("message", "Member not found"),
            HttpStatus.NOT_FOUND);
      }

      // 기존 이미지 URL 확인
      String existingImageUrl = member.getImage();
      if (existingImageUrl != null && !existingImageUrl.equals("0")) {
        String existingFileKey = existingImageUrl.substring(existingImageUrl.indexOf("uploads/"));
        try {
          // 기존 이미지 삭제
          s3Service.deleteFile(existingFileKey);
        } catch (Exception e) {
          return new ResponseEntity<>(
              Collections.singletonMap("message", "Failed to delete existing file"),
              HttpStatus.INTERNAL_SERVER_ERROR);
        }
      }

      // 새 이미지 업로드
      String imageUrl = s3Service.uploadFile(filePath, inputStream, file.getSize());
      member.setImage(imageUrl);
      memberService.modifyMemberInfo(member);

      return new ResponseEntity<>(Collections.singletonMap("message", "File uploaded successfully"),
          HttpStatus.OK);
    } catch (IOException e) {
      return new ResponseEntity<>(Collections.singletonMap("message", "File upload failed"),
          HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  private String getFileExtension(String originalFilename) {
    // 원본 파일명에서 확장자를 추출, 기본값은 ".png"
    int lastDotIndex = originalFilename.lastIndexOf('.');
    return (lastDotIndex >= 0) ? originalFilename.substring(lastDotIndex) : ".png";
  }
}
