import 'package:tutor_platform/core/properties/frontend_property.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_dto.dart';
import 'package:tutor_platform/main/domain/model/list_tile/lecture_list_tile.dart';
import 'package:tutor_platform/main/domain/repository/lecture_api_repository.dart';
import 'package:tutor_platform/main/domain/use_case/list_tile/card_view/card_scroll.dart';
import 'package:tutor_platform/main/domain/use_case/obtain_lecture.dart';

class GetOngoingLecture implements CardScroll {
  final LectureApiRepository _lectureApiRepository;
  final ObtainLecture _obtainLecture;

  GetOngoingLecture(this._lectureApiRepository, this._obtainLecture);

  int _maxElements = -1;
  int _page = 0;
  final Map<int, LectureListTile> _lectures = {};

  Future<List<int>> _getListIds(int page, int count) async {
    final Result<List<LectureDto>, String> result =
        await _lectureApiRepository.getOngoingLectures(page, count);

    late List<LectureDto> lectureList;
    switch (result) {
      case Error<List<LectureDto>,String>():
        print(result.error);
        return [];
      case Success<List<LectureDto>,String>():
        lectureList = result.value;
    }

    _maxElements = lectureList.length;

    _lectures.addAll({ for (var e in lectureList) e.id : LectureListTile.fromDto(e) });
    print(_lectures);

    return lectureList.map((e) => e.id).toList();
  }

  @override
  Future<List<int>> getCardViewListIds() {
    return _getListIds(0, FrontendProperty.finCardViewLoadCount);
  }

  @override
  Future<List<int>> initLoadIds() async {
    final idList = _getListIds(0, FrontendProperty.infListViewLoadCount);

    _page = 1;

    return idList;
  }

  @override
  Future<List<int>> loadMoreIds() async {
    if (_lectures.length >= _maxElements) {
      return [];
    }

    final idList = _getListIds(_page, FrontendProperty.infListViewLoadCount);

    _page++;

    return idList;
  }


  @override
  Future<LectureListTile> loadId(int id) async {
    if (_lectures.containsKey(id)) {
      return Future.value(_lectures[id]);
    }

    print('loadId: $id');

    final LectureDto lectureDto = await _obtainLecture.getLecture(id);

    return LectureListTile.fromDto(lectureDto);
  }

  @override
  int get maxElements => _maxElements;

  @override
  void set(Object value) {
    throw UnimplementedError();
  }
}