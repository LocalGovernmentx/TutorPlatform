import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_dto.dart';
import 'package:tutor_platform/main/domain/repository/lecture_api_repository.dart';
import 'package:tutor_platform/main/domain/use_case/obtain_lecture.dart';

class HandleOngoingLecture {
  final LectureApiRepository _lectureApiRepository;
  final ObtainLecture _obtainLecture;
  final idList = <int>[];

  HandleOngoingLecture(this._lectureApiRepository, this._obtainLecture);

  Future<List<LectureDto>> getOngoingLectures(int page, int count) async {

    final Result<List<LectureDto>, String> result =
        await _lectureApiRepository.getOngoingLectures(page, count);

    late List<LectureDto> lectureIdList;
    switch (result) {
      case Error<List<LectureDto>,String>():
        print(result.error);
        return [];
      case Success<List<LectureDto>,String>():
        lectureIdList = result.value;
    }

    idList.addAll(lectureIdList.map((e) => e.id).toList());

    print(lectureIdList);

    final lectureList = <LectureDto>[];
    for (int id in lectureIdList.map((e) => e.id).toList()) {
      final lecture = await _obtainLecture.getLecture(id);
      lectureList.add(lecture);
    }

    return lectureList;
  }

  Future<bool> toggleOngoing(int id) async {
    Result<void, String> result = await _lectureApiRepository.toggleOngoing(id);
    switch (result) {
      case Success<void, String>():
        return true;
      case Error<void, String>():
        print(result.error);
        return false;
    }
  }

  bool isOngoing(int id) {
    return idList.contains(id);
  }
}