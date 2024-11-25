package com.sm.tutor.service;

import com.sm.tutor.domain.Dibs;
import com.sm.tutor.domain.DibsId;
import com.sm.tutor.domain.Lecture;
import com.sm.tutor.domain.LectureImage;
import com.sm.tutor.domain.Member;
import com.sm.tutor.domain.dto.LectureLocationDto;
import com.sm.tutor.domain.dto.LectureSmallView;
import com.sm.tutor.repository.DibsRepository;
import com.sm.tutor.repository.LectureImageRepository;
import com.sm.tutor.repository.LectureRepository;
import com.sm.tutor.repository.MemberRepository;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class DibsService {

  @Autowired
  private MemberRepository memberRepository;

  @Autowired
  private LectureRepository lectureRepository;

  @Autowired
  private DibsRepository dibsRepository;
  @Autowired
  private LectureImageRepository lectureImageRepository;

  @Transactional
  public void addDibs(Integer lectureId, String email) {
    Optional<Member> memberOptional = memberRepository.findByEmail(email);
    Optional<Lecture> lectureOptional = lectureRepository.findById(Long.valueOf(lectureId));

    if (memberOptional.isPresent() && lectureOptional.isPresent()) {
      Member member = memberOptional.get();
      Lecture lecture = lectureOptional.get();

      DibsId dibsId = new DibsId();
      dibsId.setLectureId(lectureId);
      dibsId.setTuteeMemberId(member.getId());

      if (dibsRepository.existsById(dibsId)) {
        throw new IllegalArgumentException("Lecture is already in the favorites list");
      }

      Dibs dibs = new Dibs();
      dibs.setId(dibsId);
      dibs.setLecture(lecture);
      dibs.setTuteeMember(member);

      dibsRepository.save(dibs);
    } else {
      throw new IllegalArgumentException("Lecture or Member not found");
    }
  }

  @Transactional
  public void removeDibs(Integer lectureId, String email) {
    Optional<Member> memberOptional = memberRepository.findByEmail(email);

    if (memberOptional.isPresent()) {
      Member member = memberOptional.get();
      dibsRepository.deleteByLectureIdAndTuteeMemberId(lectureId, member.getId());
    } else {
      throw new IllegalArgumentException("Member not found");
    }
  }

  public List<LectureSmallView> getDibsLectureDetails(String email) {
    // Find member by email
    Member member = memberRepository.findByEmail(email)
        .orElseThrow(() -> new IllegalArgumentException("Member not found"));

    // Get list of lecture IDs from Dibs
    List<Integer> lectureIds = dibsRepository.findLectureIdsByTuteeMemberId(member.getId());

    // Fetch lectures and their main images
    return lectureIds.stream().map(lectureId -> {
      // Fetch lecture by ID
      Lecture lecture = lectureRepository.findById(Long.valueOf(lectureId))
          .orElseThrow(() -> new IllegalArgumentException("Lecture not found"));

      // Fetch main image
      String mainImage = lectureImageRepository.findByLectureIdAndMainImageTrue(lectureId)
          .map(LectureImage::getImage)
          .orElse(null);

      // Map lecture to DTO
      return mapToLectureSmallView(lecture, mainImage);
    }).collect(Collectors.toList());
  }

  private LectureSmallView mapToLectureSmallView(Lecture lecture, String mainImage) {
    LectureSmallView view = new LectureSmallView();
    view.setId(lecture.getId());
    view.setTitle(lecture.getTitle());
    view.setActivation(lecture.getActivation());
    view.setTutorNickname(lecture.getTutor().getMember().getNickname());
    view.setCategoryId(
        lecture.getCategoryId()); // Assuming getCategory() method returns Category entity
    view.setMainImage(mainImage);
    view.setLocations(lecture.getLocations().stream()
        .map(LectureLocationDto::fromEntity)
        .collect(Collectors.toList()));
    System.out.println(view);
    return view;
  }
}
