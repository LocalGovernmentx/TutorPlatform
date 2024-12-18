package com.sm.tutor.service;

import com.sm.tutor.domain.LocationData;
import com.sm.tutor.repository.LocationDataRepository;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class LocationService {

  private final LocationDataRepository locationDataRepository;

  public LocationData getLocationById(Long id) {
    Optional<LocationData> locationData = locationDataRepository.findById(id);

    return locationData.orElse(null);
  }
}
