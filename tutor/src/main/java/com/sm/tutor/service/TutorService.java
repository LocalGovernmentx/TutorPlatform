package com.sm.tutor.service;

import com.sm.tutor.domain.Tutor;
import com.sm.tutor.repository.TutorRepository;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class TutorService {

  private final TutorRepository tutorRepository;

  public Tutor getTutorById(Long id) {
    Optional<Tutor> locationData = tutorRepository.findById(id);

    return locationData.orElse(null);
  }

}
