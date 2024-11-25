import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_dto.dart';
import 'package:tutor_platform/main/domain/repository/lecture_api_repository.dart';
import 'package:tutor_platform/main/domain/use_case/dibs/dibs.dart';

class ObtainLecture {
  final LectureApiRepository _lectureApiRepository;
  final DibsUseCase _dibsUseCase;

  ObtainLecture(this._lectureApiRepository, this._dibsUseCase);

  Future<LectureDto> getLecture(int id) async {
    final result = await _lectureApiRepository.getLectureById(id);

    switch (result) {
      case Error<LectureDto, String>():
        throw Exception(result.error);
      case Success<LectureDto, String>():
        return result.value;
    }
  }

  // TODO: Implement tutorNickname
  String tutorNickname(int id) {
    return '사용자 이름';
  }

  bool isDib(int id) {
    return _dibsUseCase.isDib(id);
  }
}