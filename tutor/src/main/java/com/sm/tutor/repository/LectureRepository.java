package com.sm.tutor.repository;

import com.sm.tutor.domain.Lecture;
import io.lettuce.core.dynamic.annotation.Param;
import java.util.List;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface LectureRepository extends JpaRepository<Lecture, Long> {

  boolean existsById(Long id);

  Lecture getLectureById(int id);

  @Query("SELECT l FROM Lecture l " +
      "JOIN LectureLocation ll ON l.id = ll.lecture.id " +
      "JOIN LocationData loc ON ll.location.id = loc.id " +
      "WHERE (l.activation = true) AND " +
      "(:categoryId IS NULL OR l.categoryId IN :categoryId) " +
      "AND (:tuitionMaximum IS NULL OR l.tuitionMaximum <= :tuitionMaximum) " +
      "AND (:locationId IS NULL OR loc.id IN :locationId) " +
      "AND (:online IS NULL OR l.online = :online) " +
      "AND (:keyword IS NULL OR (l.title LIKE CONCAT('%', :keyword, '%') OR l.content LIKE CONCAT('%', :keyword, '%')))")
  List<Lecture> findAllByFilter(@Param("categoryId") List<Integer> categoryId,
      @Param("tuitionMaximum") Integer tuitionMaximum,
      @Param("locationId") List<Integer> locationId, @Param("online") Integer online,
      @Param("keyword") String keyword, Pageable pageable);
}
