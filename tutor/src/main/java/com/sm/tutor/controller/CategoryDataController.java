package com.sm.tutor.controller;

import com.sm.tutor.domain.CategoryData;
import com.sm.tutor.service.CategoryDataService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import java.util.Collections;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/category")
public class CategoryDataController {

  @Autowired
  private CategoryDataService categoryDataService;

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: 성공"),
  })
  @Operation(summary = "모든 category data 조회",
      description = "모든 카테고리 데이터를 조회합니다. \n" +
          "조회에 성공하면 카테고리 데이터를 `200 OK` 상태 코드와 함께 반환됩니다.")
  @GetMapping
  public ResponseEntity<List<CategoryData>> getAllCategoryData() {
    List<CategoryData> categoryDataList = categoryDataService.getAllCategoryData();
    return new ResponseEntity<>(categoryDataList, HttpStatus.OK);
  }

  @ApiResponses(value = {
      @ApiResponse(responseCode = "200", description = "OK: 성공"),
      @ApiResponse(responseCode = "404", description = "NOT_FOUND: ID not found")
  })
  @Operation(summary = "category_id를 이용하여 category data 조회",
      description = "카테고리의 ID를 사용하여 카테고리 데이터를 조회합니다. \n" +
          "요청된 ID가 데이터베이스에 존재하지 않는 경우 `404 Not Found` 상태 코드와 함께 에러 메시지를 반환합니다. \n"
          +
          "조회에 성공하면 카테고리 데이터를 `200 OK` 상태 코드와 함께 반환됩니다.")
  @GetMapping("/{id}")
  public ResponseEntity<?> getCategoryDataById(@PathVariable Long id) {
    CategoryData categoryData = categoryDataService.getCategoryDataById(id);
    if (categoryData == null) {
      return new ResponseEntity<>(Collections.singletonMap("message", "ID not found"), HttpStatus.NOT_FOUND);
    }
    return new ResponseEntity<>(categoryData, HttpStatus.OK);
  }
}
