package com.sm.tutor.repository;

import com.sm.tutor.domain.CategoryData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoryDataRepository extends JpaRepository<CategoryData, Long> {

}
