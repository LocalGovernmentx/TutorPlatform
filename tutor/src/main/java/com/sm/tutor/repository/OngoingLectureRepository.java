package com.sm.tutor.repository;

import com.sm.tutor.domain.Member;
import com.sm.tutor.domain.OngoingLecture;
import com.sm.tutor.domain.OngoingLectureId;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OngoingLectureRepository extends JpaRepository<OngoingLecture, OngoingLectureId> {

  List<OngoingLecture> findTop6ByTuteeMemberOrderByLectureIdDesc(Member tuteeMember);

  boolean existsById(OngoingLectureId id);

}