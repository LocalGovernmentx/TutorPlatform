package com.sm.tutor.service;

import com.sm.tutor.domain.Member;
import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ImageService {

  private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
  private final S3Service s3Service;
  private final MemberService memberService;

  public ImageService(S3Service s3Service, MemberService memberService) {
    this.s3Service = s3Service;
    this.memberService = memberService;
  }

  private String decodeUrl(String encodedUrl) {
    return URLDecoder.decode(encodedUrl, StandardCharsets.UTF_8);
  }

  public String uploadImage(String email, MultipartFile file) {
    try {
      validateFile(file);

      // 파일 이름 설정 (이메일 주소 기반)
      String fileName = email + "-profile" + getFileExtension(file.getOriginalFilename());
      String folderPath = "uploads/profiles/";
      String filePath = folderPath + fileName;
      // 현재 프로필 이미지 URL을 멤버에서 가져오기
      Member member = memberService.getMemberByEmail(email);
      if (member == null) {
        return "Member not found";
      }

      // 기존 이미지 URL 확인
      String existingImageUrl = member.getImage();
      if (existingImageUrl != null && !existingImageUrl.equals("0")) {
        String existingFileKey = existingImageUrl.substring(existingImageUrl.indexOf("uploads/"));
        try {
          // 기존 이미지 삭제
          s3Service.deleteFile(existingFileKey);
        } catch (Exception e) {
          return "Failed to delete existing file";
        }
      }

      // 새 이미지 업로드
      String imageUrl = s3Service.uploadFile(filePath, file.getInputStream(), file.getSize());
      String decodedImageUrl = decodeUrl(imageUrl);

      member.setImage(decodedImageUrl);
      memberService.modifyMemberInfo(member);

      return "File uploaded successfully";
    } catch (IOException e) {
      return "File upload failed: " + e.getMessage();
    }
  }

  public String deleteImage(String email) {
    try {
      // 현재 프로필 이미지 URL을 멤버에서 가져오기
      Member member = memberService.getMemberByEmail(email);
      if (member == null) {
        return "Member not found";
      }

      // 기존 이미지 URL 확인
      String existingImageUrl = member.getImage();
      if (existingImageUrl != null && !existingImageUrl.equals("0")) {
        String existingFileKey = existingImageUrl.substring(existingImageUrl.indexOf("uploads/"));
        try {
          System.out.println(existingFileKey);
          // 기존 이미지 삭제
          s3Service.deleteFile(existingFileKey);
          member.setImage("0"); // 이미지 URL을 초기화
          memberService.modifyMemberInfo(member);
          return "Image deleted successfully";
        } catch (Exception e) {
          return "Failed to delete existing file";
        }
      } else {
        return "No image to delete";
      }
    } catch (Exception e) {
      return "Error occurred while deleting image: " + e.getMessage();
    }
  }

  private void validateFile(MultipartFile file) throws IOException {
    if (file.isEmpty()) {
      throw new IOException("No file selected");
    }

    String contentType = file.getContentType();
    if (contentType == null || !contentType.startsWith("image/")) {
      throw new IOException("Invalid file type");
    }

    if (file.getSize() > MAX_FILE_SIZE) {
      throw new IOException("File size exceeds limit");
    }
  }

  private String getFileExtension(String originalFilename) {
    // 원본 파일명에서 확장자를 추출, 기본값은 ".png"
    int lastDotIndex = originalFilename.lastIndexOf('.');
    return (lastDotIndex >= 0) ? originalFilename.substring(lastDotIndex) : ".png";
  }
}
