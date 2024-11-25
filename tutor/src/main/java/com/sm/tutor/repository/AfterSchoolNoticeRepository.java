package com.sm.tutor.repository;

import com.sm.tutor.domain.AfterSchoolNotice;
import io.lettuce.core.dynamic.annotation.Param;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface AfterSchoolNoticeRepository extends JpaRepository<AfterSchoolNotice, Long> {

  @Query(value = "SELECT a FROM AfterSchoolNotice a " +
      "WHERE " +
      "(:region IS NULL OR a.region = :region)")
  List<AfterSchoolNotice> findAllByFilter(@Param("region") String region);
}
