package com.sm.tutor.converter;

import com.sm.tutor.domain.AfterSchoolNotice;
import com.sm.tutor.domain.dto.SimpleAfterSchoolNoticeResponseDto;
import org.springframework.stereotype.Service;

@Service
public class SimpleAfterSchoolConverter {

  public SimpleAfterSchoolNoticeResponseDto toDto(AfterSchoolNotice afterSchoolNotice) {
    return new SimpleAfterSchoolNoticeResponseDto(afterSchoolNotice.getId(), afterSchoolNotice.getTitle(), afterSchoolNotice.getContent(),
        afterSchoolNotice.getRegion());
  }
}
