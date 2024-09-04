package com.sm.tutor.service;

import com.sm.tutor.converter.LectureConverter;
import com.sm.tutor.converter.SimpleLectureConverter;
import com.sm.tutor.domain.Lecture;
import com.sm.tutor.domain.LectureAge;
import com.sm.tutor.domain.LectureImage;
import com.sm.tutor.domain.LectureLocation;
import com.sm.tutor.domain.LectureReview;
import com.sm.tutor.domain.LectureTime;
import com.sm.tutor.domain.Member;
import com.sm.tutor.domain.OngoingLecture;
import com.sm.tutor.domain.OngoingLectureId;
import com.sm.tutor.domain.dto.LectureDto;
import com.sm.tutor.domain.dto.SimpleLectureResponseDto;
import com.sm.tutor.repository.LectureAgeRepository;
import com.sm.tutor.repository.LectureImageRepository;
import com.sm.tutor.repository.LectureLocationRepository;
import com.sm.tutor.repository.LectureRepository;
import com.sm.tutor.repository.LectureReviewRepository;
import com.sm.tutor.repository.LectureTimeRepository;
import com.sm.tutor.repository.MemberRepository;
import com.sm.tutor.repository.OngoingLectureRepository;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
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
  private final MemberRepository memberRepository;
  @Autowired
  private OngoingLectureRepository ongoingLectureRepository;

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

  public List<LectureDto> getOngoingLectures(String email) {
    Optional<Member> member = memberRepository.findByEmail(email);

    if (member.isPresent()) {
      List<OngoingLecture> ongoingLectures = ongoingLectureRepository
          .findTop6ByTuteeMemberOrderByLectureIdDesc(member.get());

      return ongoingLectures.stream()
          .map(ongoingLecture -> LectureDto.fromEntity(ongoingLecture.getLecture()))
          .collect(Collectors.toList());
    } else {
      throw new IllegalArgumentException("Member not found");
    }
  }

  // 강의 시작 (듣기)
  public LectureDto startLecture(Long lectureId, String email) {
    // 이메일로 회원을 조회
    Optional<Member> memberOptional = memberRepository.findByEmail(email);
    // 강의 ID로 강의를 조회
    Optional<Lecture> lectureOptional = lectureRepository.findById(lectureId);

    // 회원과 강의가 존재하는지 확인
    if (memberOptional.isEmpty() || lectureOptional.isEmpty()) {
      throw new IllegalArgumentException("Lecture or Member not found");
    }

    // 회원과 강의 객체 가져오기
    Member member = memberOptional.get();
    Lecture lecture = lectureOptional.get();

    // 이미 해당 강의를 듣고 있는지 확인
    OngoingLectureId ongoingLectureId = new OngoingLectureId();
    ongoingLectureId.setLectureId(lectureId.intValue());
    ongoingLectureId.setTuteeMemberId(member.getId());

    if (ongoingLectureRepository.existsById(ongoingLectureId)) {
      throw new IllegalArgumentException("Already enrolled in this lecture");
    }

    // OngoingLecture 객체 생성
    OngoingLecture ongoingLecture = new OngoingLecture();
    ongoingLecture.setId(ongoingLectureId); // 복합 키 설정
    ongoingLecture.setLecture(lecture);
    ongoingLecture.setTuteeMember(member);

    // OngoingLecture 저장
    ongoingLectureRepository.save(ongoingLecture);

    // DTO로 변환하여 반환
    return LectureDto.fromEntity(lecture);
  }


  public Page<SimpleLectureResponseDto> getLectureByFilter(Pageable pageable,
      List<Integer> categoryId, Integer tuitionMaximum,
      List<Integer> locationId, Integer online, String keyword) {
    List<Lecture> lecturePages = lectureRepository.findAllByFilter(categoryId, tuitionMaximum,
        locationId, online, keyword);

    // SimpleLectureResponseDto로 2차 가공
    List<SimpleLectureResponseDto> simpleLectureResponseList = lecturePages.stream()
        .map(simpleLectureConverter::toDto).collect(Collectors.toList());

    PageRequest pageRequest = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize());
    int start = (int) pageRequest.getOffset();
    int end = Math.min((start + pageRequest.getPageSize()), simpleLectureResponseList.size());

    Page<SimpleLectureResponseDto> simpleLectureResponsePages = new PageImpl<>(
        simpleLectureResponseList.subList(start, end), pageRequest,
        simpleLectureResponseList.size());
    return simpleLectureResponsePages;
  }

}
