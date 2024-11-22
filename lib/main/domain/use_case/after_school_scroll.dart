import 'package:tutor_platform/core/properties/frontend_property.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/domain/model/dto/after_school_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/page_simple_after_school_notice_response_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/simple_after_school_notice_response_dto.dart';
import 'package:tutor_platform/main/domain/model/list_tile/list_tile_objects.dart';
import 'package:tutor_platform/main/domain/repository/after_school_repository.dart';
import 'package:tutor_platform/main/domain/use_case/list_tile/scroll.dart';

class AfterSchoolScroll implements ScrollUseCase<SimpleAfterSchoolNoticeResponseDto> {
  final AfterSchoolRepository repository;

  AfterSchoolScroll(this.repository);

  int _maxElements = -1;
  int _page = 0;
  final Map<int, SimpleAfterSchoolNoticeResponseDto> _lectures = {};

  @override
  Future<List<int>> initLoadIds() async {
    final Result<PageSimpleAfterSchoolNoticeResponseDto, String> result =
        await repository.getAfterSchoolNotices(
      0,
      FrontendProperty.infListViewLoadCount,
    );

    late PageSimpleAfterSchoolNoticeResponseDto pageLectureDto;
    if (result is Error<PageSimpleAfterSchoolNoticeResponseDto, String>) {
      print(result.error);
      return [];
    } else if (result is Success<PageSimpleAfterSchoolNoticeResponseDto, String>) {
      pageLectureDto = result.value;
    }

    _maxElements = pageLectureDto.totalElements;
    _page = 1;

    _lectures.clear();
    for (var e in pageLectureDto.content) {
      _lectures[e.id] = e;
    }

    return pageLectureDto.content.map((e) => e.id).toList();
  }

  @override
  Future<SimpleAfterSchoolNoticeResponseDto> loadId(int id) async {
    if (_lectures.containsKey(id)) {
      return _lectures[id]!;
    }

    throw Exception('No such id');
  }

  @override
  Future<List<int>> loadMoreIds() async {
    if (_lectures.length >= _maxElements) {
      return [];
    }

    final Result<PageSimpleAfterSchoolNoticeResponseDto, String> result =
        await repository.getAfterSchoolNotices(
      _page,
      FrontendProperty.infListViewLoadCount,
    );

    late PageSimpleAfterSchoolNoticeResponseDto pageLectureDto;
    if (result is Error<PageSimpleAfterSchoolNoticeResponseDto, String>) {
      print(result.error);
      return [];
    } else if (result is Success<PageSimpleAfterSchoolNoticeResponseDto, String>) {
      pageLectureDto = result.value;
    }

    _page++;

    for (var e in pageLectureDto.content) {
      _lectures[e.id] = e;
    }

    return pageLectureDto.content.map((e) => e.id).toList();
  }

  @override
  int get maxElements => _maxElements;

  @override
  void set(Object value) {
    // do nothing
  }
}