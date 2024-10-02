package com.sm.tutor.service;

import com.sm.tutor.domain.CategoryData;
import com.sm.tutor.repository.CategoryDataRepository;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Slf4j
@Transactional
@RequiredArgsConstructor
public class CategoryDataService {

  private final CategoryDataRepository categoryDataRepository;

  public List<CategoryData> getAllCategoryData() {
    return categoryDataRepository.findAll();
  }

  public CategoryData getCategoryDataById(Long id) {
    Optional<CategoryData> categoryData = categoryDataRepository.findById(id);
    return categoryData.orElse(null);
  }

}
