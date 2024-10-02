package com.sm.tutor.controller;

import com.sm.tutor.service.ImageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.Collections;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/images")
public class ImageController {

  @Autowired
  private ImageService imageService;

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
      HttpServletRequest request) throws IOException {
    // 사용자 이메일을 요청 속성에서 가져오기
    String email = (String) request.getAttribute("userEmail");
    if (email == null) {
      return new ResponseEntity<>(Collections.singletonMap("message", "Invalid token"),
          HttpStatus.UNAUTHORIZED);
    }

    String resultMessage = imageService.uploadImage(email, "profile", file);
// string -> code
    if (resultMessage.equals("File uploaded successfully")) {
      return new ResponseEntity<>(Collections.singletonMap("message", resultMessage),
          HttpStatus.OK);
    } else if (resultMessage.equals("Member not found")) {
      return new ResponseEntity<>(Collections.singletonMap("message", resultMessage),
          HttpStatus.NOT_FOUND);
    } else if (resultMessage.equals("Failed to delete existing file")) {
      return new ResponseEntity<>(Collections.singletonMap("message", resultMessage),
          HttpStatus.INTERNAL_SERVER_ERROR);
    } else if (resultMessage.startsWith("File upload failed")) {
      return new ResponseEntity<>(Collections.singletonMap("message", resultMessage),
          HttpStatus.BAD_REQUEST);
    } else {
      return new ResponseEntity<>(Collections.singletonMap("message", "Unknown error"),
          HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }


  @Operation(
      summary = "회원 프로필 이미지 삭제",
      description = "회원의 프로필 이미지를 삭제합니다.",
      responses = {
          @ApiResponse(responseCode = "200", description = "파일 삭제 성공"),
          @ApiResponse(responseCode = "401", description = "인증 실패"),
          @ApiResponse(responseCode = "404", description = "회원 찾을 수 없음"),
          @ApiResponse(responseCode = "500", description = "서버 오류 (파일 삭제 실패 등)")
      }
  )
  @DeleteMapping("/member")
  public ResponseEntity<?> deleteImage(HttpServletRequest request) {
    // 사용자 이메일을 요청 속성에서 가져오기
    String email = (String) request.getAttribute("userEmail");
    if (email == null) {
      return new ResponseEntity<>(
          Collections.singletonMap("message", "Invalid token or email mismatch"),
          HttpStatus.UNAUTHORIZED);
    }

    String resultMessage = imageService.deleteImage(email);

    if (resultMessage.equals("Image deleted successfully")) {
      return new ResponseEntity<>(Collections.singletonMap("message", resultMessage),
          HttpStatus.OK);
    } else if (resultMessage.equals("Member not found")) {
      return new ResponseEntity<>(Collections.singletonMap("message", resultMessage),
          HttpStatus.NOT_FOUND);
    } else if (resultMessage.equals("Failed to delete existing file")) {
      return new ResponseEntity<>(Collections.singletonMap("message", resultMessage),
          HttpStatus.INTERNAL_SERVER_ERROR);
    } else if (resultMessage.equals("No image to delete")) {
      return new ResponseEntity<>(Collections.singletonMap("message", resultMessage),
          HttpStatus.NOT_FOUND);
    } else {
      return new ResponseEntity<>(Collections.singletonMap("message", "Unknown error"),
          HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }
}
