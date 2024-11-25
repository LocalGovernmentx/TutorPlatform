package com.sm.tutor.service;

import com.sm.tutor.converter.SimpleAfterSchoolConverter;
import com.sm.tutor.domain.AfterSchoolNotice;
import com.sm.tutor.domain.dto.SimpleAfterSchoolNoticeResponseDto;
import com.sm.tutor.repository.AfterSchoolNoticeRepository;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class AfterSchoolService {

  private final AfterSchoolNoticeRepository afterSchoolNoticeRepository;

  private final SimpleAfterSchoolConverter simpleAfterSchoolConverter;

  public AfterSchoolNotice getAfterSchoolNoticeById(Long id) {
    Optional<AfterSchoolNotice> afterSchoolNotice = afterSchoolNoticeRepository.findById(id);
    return afterSchoolNotice.orElse(null);
  }

  public Page<SimpleAfterSchoolNoticeResponseDto> getAfterSchoolNoticeByFilter(Pageable pageable,
      String region) {
    List<AfterSchoolNotice> afterSchoolNoticePages = afterSchoolNoticeRepository.findAllByFilter(region);

    // SimpleLectureResponseDto로 2차 가공
    List<SimpleAfterSchoolNoticeResponseDto> simpleAfterSchoolNoticeResponseDtoList = afterSchoolNoticePages.stream()
        .map(simpleAfterSchoolConverter::toDto).toList();

    PageRequest pageRequest = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize());
    int start = (int) pageRequest.getOffset();
    int end = Math.min((start + pageRequest.getPageSize()), simpleAfterSchoolNoticeResponseDtoList.size());

    Page<SimpleAfterSchoolNoticeResponseDto> simpleAfterSchoolNoticeResponseDtoPages = new PageImpl<>(
        simpleAfterSchoolNoticeResponseDtoList.subList(start, end), pageRequest,
        simpleAfterSchoolNoticeResponseDtoList.size());
    return simpleAfterSchoolNoticeResponseDtoPages;
  }
}
