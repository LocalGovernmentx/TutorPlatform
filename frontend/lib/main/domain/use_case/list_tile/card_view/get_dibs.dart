import 'dart:math';

import 'package:tutor_platform/core/properties/frontend_property.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_dto.dart';
import 'package:tutor_platform/main/domain/model/list_tile/lecture_list_tile.dart';
import 'package:tutor_platform/main/domain/use_case/dibs/dibs_lecture.dart';
import 'package:tutor_platform/main/domain/use_case/list_tile/card_view/card_scroll.dart';
import 'package:tutor_platform/main/domain/use_case/obtain_lecture.dart';

class GetDibs implements CardScroll {
  final DibsLectureUseCase _dibsLectureUseCase;
  final ObtainLecture _obtainLecture;

  GetDibs(this._dibsLectureUseCase, this._obtainLecture);

  final List<int> _dibs = [];
  final Map<int, LectureListTile> _lectures = {};

  int _page = 0;

  @override
  int get maxElements => _dibs.length;

  Future<void> _getDibList() async {
    final dibs = await _dibsLectureUseCase.reloadDibs();
    _dibs.addAll(dibs);
  }

  @override
  Future<List<int>> getCardViewListIds() async {
    await _getDibList();

    int countLoadAtOnce = FrontendProperty.finCardViewLoadCount;
    final sublist = _dibs.sublist(0, min(countLoadAtOnce, _dibs.length));
    return sublist;
  }

  List<int> _listViewLoadIds() {
    int countLoadAtOnce = FrontendProperty.infListViewLoadCount;
    final List<int> tempStore = _dibs.sublist(_page * countLoadAtOnce, min((_page + 1) * countLoadAtOnce, _dibs.length));

    _page++;

    return tempStore;
  }

  @override
  Future<List<int>> initLoadIds() async {
    await _getDibList();

    _page = 0;

    return _listViewLoadIds();
  }

  @override
  Future<List<int>> loadMoreIds() {
    return Future.value(_listViewLoadIds());
  }

  @override
  Future<LectureListTile> loadId(int id) async {
    if (_lectures.containsKey(id)) {
      return _lectures[id]!;
    }

    final LectureDto lectureDto = await _obtainLecture.getLecture(id);
    _lectures[id] = LectureListTile.fromLectureDto(lectureDto);

    return _lectures[id]!;
  }

  @override
  void set(Object value) {
    throw UnimplementedError();
  }

}