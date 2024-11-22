import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_dto.dart';
import 'package:tutor_platform/main/domain/model/list_tile/lecture_list_tile.dart';
import 'package:tutor_platform/main/domain/model/list_tile/list_tile_objects.dart';
import 'package:tutor_platform/main/domain/repository/lecture_api_repository.dart';
import 'package:tutor_platform/main/domain/use_case/list_tile/scroll.dart';
import 'package:tutor_platform/main/domain/use_case/obtain_lecture.dart';

class MyLectures extends ScrollUseCase<LectureListTile> {
  final LectureApiRepository lectureApiRepository;
  final ObtainLecture obtainLecture;

  MyLectures(this.lectureApiRepository, this.obtainLecture);

  late int _maxElements;

  @override
  Future<List<int>> initLoadIds() async {
    print('initLoadIds');
    Result<List<int>, String> result = await lectureApiRepository.getMyLectureIds();
    print('result: $result');
    switch (result) {
      case Success<List<int>, String>():
        print(result.value);
        _maxElements = result.value.length;
        return result.value;
      case Error<List<int>, String>():
        print(result.error);
        _maxElements = 0;
        return [];
    }
  }

  @override
  Future<LectureListTile> loadId(int id) async {
    LectureDto lectureDto = await obtainLecture.getLecture(id);
    return LectureListTile.fromLectureDto(lectureDto);
  }

  @override
  Future<List<int>> loadMoreIds() {
    throw UnimplementedError();
  }

  @override
  int get maxElements => _maxElements;

  @override
  void set(Object value) {
    throw UnimplementedError();
  }
}