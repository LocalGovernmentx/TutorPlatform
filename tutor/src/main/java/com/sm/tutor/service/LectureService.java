package com.sm.tutor.service;

import com.sm.tutor.converter.LectureConverter;
import com.sm.tutor.converter.SimpleLectureConverter;
import com.sm.tutor.domain.Lecture;
import com.sm.tutor.domain.LectureAge;
import com.sm.tutor.domain.LectureImage;
import com.sm.tutor.domain.LectureLocation;
import com.sm.tutor.domain.LectureReview;
import com.sm.tutor.domain.LectureTime;
import com.sm.tutor.domain.dto.LectureDto;
import com.sm.tutor.domain.dto.SimpleLectureResponseDto;
import com.sm.tutor.repository.LectureAgeRepository;
import com.sm.tutor.repository.LectureImageRepository;
import com.sm.tutor.repository.LectureLocationRepository;
import com.sm.tutor.repository.LectureRepository;
import com.sm.tutor.repository.LectureReviewRepository;
import com.sm.tutor.repository.LectureTimeRepository;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class LectureService {

  private final LectureRepository lectureRepository;
  private final LectureAgeRepository lectureAgeRepository;
  private final LectureImageRepository lectureImageRepository;
  private final LectureLocationRepository lectureLocationRepository;
  private final LectureReviewRepository lectureReviewRepository;
  private final LectureTimeRepository lectureTimeRepository;

  private final LectureConverter lectureConverter;
  private final SimpleLectureConverter simpleLectureConverter;

  private final MemberService memberService;
  private final TutorService tutorService;
  private final LocationService locationService;

  public List<LectureDto> getAllLecturesWithDetails() {
    return lectureRepository.findAll().stream().map(lectureConverter::toDto)
        .collect(
            Collectors.toList());
  }

  public LectureDto createLecture(LectureDto lecturedto) {
    log.info("LectureDto: {}", lecturedto.toString());
    Lecture lecture = lecturedto.toEntity(
        tutorService.getTutorById(Long.valueOf(lecturedto.getTutorId())),
        new ArrayList<>(), new ArrayList<>(), new ArrayList<>(), new ArrayList<>(),
        new ArrayList<>());
    List<LectureAge> ageList = lecturedto.getAges().stream().map(m -> m.toEntity(lecture))
        .collect(Collectors.toList());
    List<LectureImage> imageList = lecturedto.getImages().stream().map(m -> m.toEntity(lecture))
        .collect(Collectors.toList());
    List<LectureLocation> locationList = lecturedto.getLocations().stream()
        .map(m -> m.toEntity(lecture,
            locationService.getLocationById(Long.valueOf(m.getLocationId()))))
        .collect(Collectors.toList());
    List<LectureReview> reviewList = lecturedto.getReviews().stream()
        .map(m -> m.toEntity(lecture, memberService.getMemberById(Long.valueOf(m.getTuteeId()))))
        .collect(Collectors.toList());
    List<LectureTime> timeList = lecturedto.getTimes().stream().map(m -> m.toEntity(lecture))
        .collect(Collectors.toList());

    lecture.setAges(ageList);
    lecture.setImages(imageList);
    lecture.setLocations(locationList);
    lecture.setReviews(reviewList);
    lecture.setTimes(timeList);

    LectureDto lectureDtoResult = lectureConverter.toDto(
        lectureRepository.save(lecture));

    lectureAgeRepository.saveAll(ageList);
    lectureImageRepository.saveAll(imageList);
    lectureLocationRepository.saveAll(locationList);
    lectureReviewRepository.saveAll(reviewList);
    lectureTimeRepository.saveAll(timeList);

    return lectureDtoResult;
  }

  /*public Lecture updateLecture(Long id, Lecture updatedLecture) {
    Optional<Lecture> findLecture = lectureRepository.findById(id);
    if (findLecture.isPresent()) {

      updatedLecture.setId(id);
      return lectureRepository.save(updatedLecture);
    }
    throw new EntityNotFoundException("Lecture not found with id " + id);
  }*/

  public boolean deleteLectureById(Long id) {
    if (lectureRepository.existsById(id)) {
      lectureRepository.deleteById(id);
      return true;
    } else {
      return false;
      //throw new EntityNotFoundException("Lecture not found with id " + id);
    }
  }

  public LectureDto getLectureById(Long id) {
    Optional<Lecture> lecture = lectureRepository.findById(id);
    return lecture.map(lectureConverter::toDto).orElse(null);
  }

  public Page<LectureDto> paging(Pageable pageable) {
    // 한 페이지당 3개식 글을 보여주고 정렬 기준은 ID 기준으로 내림차순
    // Page<Lecture> lecturePages = lectureRepository.findAll(PageRequest.of(page, pageLimit, Sort.by(Direction.DESC, "id")));
    Page<Lecture> lecturePages = lectureRepository.findAll(pageable);

    return lecturePages.map(lectureConverter::toDto);
  }

  public Page<SimpleLectureResponseDto> getLectureByFilter(Pageable pageable/*filtering condition*/) {
    Page<Lecture> lecturePages = lectureRepository.findAll(pageable);

    // SimpleLectureResponseDto로 2차 가공
    List<SimpleLectureResponseDto> simpleLectureResponseList = lecturePages.stream().map(simpleLectureConverter::toDto).collect(Collectors.toList());

    PageRequest pageRequest = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize());
    int start = (int) pageRequest.getOffset();
    int end = Math.min((start + pageRequest.getPageSize()), simpleLectureResponseList.size());

    Page<SimpleLectureResponseDto> simpleLectureResponsePages = new PageImpl<>(simpleLectureResponseList.subList(start, end), pageRequest,
        simpleLectureResponseList.size());
    return simpleLectureResponsePages;
  }
}
