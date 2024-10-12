import 'package:tutor_platform/core/properties/frontend_property.dart';
import 'package:tutor_platform/core/properties/lecture_information.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/domain/model/dto/category_data.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/page_lecture_dto.dart';
import 'package:tutor_platform/main/domain/model/list_tile/lecture_list_tile.dart';
import 'package:tutor_platform/main/domain/repository/lecture_api_repository.dart';
import 'package:tutor_platform/main/domain/use_case/list_tile/scroll.dart';
import 'package:tutor_platform/main/domain/use_case/obtain_lecture.dart';

class LecturePaging implements ScrollUseCase<LectureListTile> {
  final LectureApiRepository _lectureApiRepository;
  final ObtainLecture _obtainLecture;

  LecturePaging(this._lectureApiRepository, this._obtainLecture);

  int _maxElements = -1;
  int _page = 0;
  final Map<int, LectureListTile> _lectures = {};

  OnOffline _onOffline = OnOffline.both;
  int? _maxPrice;
  List<CategoryData> _categories = [];

  @override
  Future<List<int>> initLoadIds() async {
    final Result<PageLectureDto, String> result =
        await _lectureApiRepository.getLectures(
      0,
      FrontendProperty.infListViewLoadCount,
      _categories.map((e) => e.id).toList(),
      _onOffline.index,
      _maxPrice,
    );

    late PageLectureDto pageLectureDto;
    if (result case Error<PageLectureDto, String>()) {
      print(result.error);
      return [];
    } else if (result case Success<PageLectureDto, String>()) {
      pageLectureDto = result.value;
    }

    _maxElements = pageLectureDto.totalElements;
    _page = 1;

    _lectures.clear();
    _lectures.addAll({
      for (var e in pageLectureDto.content) e.id: LectureListTile.fromDto(e)
    });
    print(_lectures);

    return pageLectureDto.content.map((e) => e.id).toList();
  }

  @override
  Future<LectureListTile> loadId(int id) async {
    if (_lectures.containsKey(id)) {
      return _lectures[id]!;
    }

    final LectureDto lectureDto = await _obtainLecture.getLecture(id);
    _lectures[id] = LectureListTile.fromDto(lectureDto);

    return _lectures[id]!;
  }

  @override
  Future<List<int>> loadMoreIds() async {
    if (_lectures.length >= _maxElements) {
      return [];
    }

    final Result<PageLectureDto, String> result = await _lectureApiRepository
        .getLectures(_page, FrontendProperty.infListViewLoadCount, _categories.map((e) => e.id).toList(), _onOffline.index, _maxPrice);

    late PageLectureDto pageLectureDto;
    if (result case Error<PageLectureDto, String>()) {
      return [];
    } else if (result case Success<PageLectureDto, String>()) {
      pageLectureDto = result.value;
    }

    _page++;

    _lectures.addAll({
      for (var e in pageLectureDto.content) e.id: LectureListTile.fromDto(e)
    });

    return pageLectureDto.content.map((e) => e.id).toList();
  }

  @override
  int get maxElements => _maxElements;

  @override
  void set(Object value) {
    if (value is OnOffline) {
      _onOffline = value;
    }
    if (value is int) {
      if (value < -1) {
        _maxPrice = null;
      } else {
        _maxPrice = value;
      }
    }
    if (value is List<CategoryData>) {
      _categories = value;
    }
  }
}
