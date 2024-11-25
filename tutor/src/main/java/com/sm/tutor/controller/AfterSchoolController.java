package com.sm.tutor.controller;

import com.sm.tutor.domain.AfterSchoolNotice;
import com.sm.tutor.domain.dto.SimpleAfterSchoolNoticeResponseDto;
import com.sm.tutor.service.AfterSchoolService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import java.util.Collections;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/after-school")
public class AfterSchoolController {

  @Autowired
  private AfterSchoolService afterschoolService;

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: 성공"),
  })
  @Operation(summary = "지역에 따른 모든 after school notice 조회",
      description = """
          지역에 따른 모든 방과후학교 강사 공고를 조회합니다.
          \s
          조회에 성공하면 방과후학교 강사 공고 데이터를 `200 OK` 상태 코드와 함께 반환됩니다.
          \s
          지역 정보를 입력할 경우 해당 지역에 대한 공고만을 가져오게 됩니다. 지역 정보를 입력하지 않으면 모든 지역에 대한 공고를 가져오게 됩니다.
          \s
          현재 사용 가능한 지역은 Busan, Incheon, Daegu 가 있습니다.
          \s
          강의 paging, list API와 같이 Page로 제공합니다.""")
  @GetMapping
  public ResponseEntity<Page<SimpleAfterSchoolNoticeResponseDto>> getAllAfterSchoolNoticeByFilter(
      @PageableDefault(page = 0, size = 10, sort = {"id"}) Pageable pageable, @RequestParam(required = false) String region) {
    Page<SimpleAfterSchoolNoticeResponseDto> afterSchoolNoticeList = afterschoolService.getAfterSchoolNoticeByFilter(pageable, region);
    return new ResponseEntity<>(afterSchoolNoticeList, HttpStatus.OK);
  }

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: 성공"),
      @ApiResponse(responseCode = "404", description = "NOT_FOUND: ID not found")
  })
  @Operation(summary = "after_school_notice_id를 이용하여 after school notice 조회",
      description = """
          방과후학교 강사 공고의 ID를 사용하여 방과후학교 강사 공고를 조회합니다.
          \s
          요청된 ID가 데이터베이스에 존재하지 않는 경우 `404 Not Found` 상태 코드와 함께 에러 메시지를 반환합니다.
          \s
          조회에 성공하면 방과후학교 강사 공고 데잍터를 `200 OK` 상태 코드와 함께 반환됩니다.""")
  @GetMapping("/{id}")
  public ResponseEntity<?> getAfterSchoolNoticeById(@PathVariable Long id) {
    AfterSchoolNotice afterSchoolNotice = afterschoolService.getAfterSchoolNoticeById(id);
    if (afterSchoolNotice == null) {
      return new ResponseEntity<>(Collections.singletonMap("message", "ID not found"), HttpStatus.NOT_FOUND);
    }
    return new ResponseEntity<>(afterSchoolNotice, HttpStatus.OK);
  }
}
