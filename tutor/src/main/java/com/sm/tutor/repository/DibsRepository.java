package com.sm.tutor.repository;

import com.sm.tutor.domain.Dibs;
import com.sm.tutor.domain.DibsId;
import io.lettuce.core.dynamic.annotation.Param;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface DibsRepository extends JpaRepository<Dibs, DibsId> {

  boolean existsById(DibsId id);

  void deleteByLectureIdAndTuteeMemberId(Integer lectureId, Integer memberId);

  @Query("SELECT d FROM Dibs d WHERE d.tuteeMember.id = :memberId")
  List<Dibs> findByTuteeMemberId(@Param("memberId") Integer memberId);

  @Query("SELECT d.lecture.id FROM Dibs d WHERE d.tuteeMember.id = :memberId")
  List<Integer> findLectureIdsByTuteeMemberId(@Param("memberId") Integer memberId);
}
