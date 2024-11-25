package com.sm.tutor.repository;

import com.sm.tutor.domain.LectureImage;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface LectureImageRepository extends JpaRepository<LectureImage, Long> {

  Optional<LectureImage> findByLectureIdAndMainImageTrue(Integer lectureId);

}
