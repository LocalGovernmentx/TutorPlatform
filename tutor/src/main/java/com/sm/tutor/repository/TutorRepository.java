package com.sm.tutor.repository;

import com.sm.tutor.domain.Tutor;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TutorRepository extends JpaRepository<Tutor, Long> {

}
