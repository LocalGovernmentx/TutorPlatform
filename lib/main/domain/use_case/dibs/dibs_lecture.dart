import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_small_view.dart';
import 'package:tutor_platform/main/domain/repository/dibs_api_repository.dart';
import 'package:tutor_platform/main/domain/use_case/dibs/dibs.dart';

class DibsLectureUseCase implements DibsUseCase {
  final DibsApiRepository _dibsApiRepository;
  final List<int> _dibs = [];

  DibsLectureUseCase(this._dibsApiRepository) {
    initDibs();
  }

  @override
  Future<void> initDibs() async {
    final result = await _dibsApiRepository.getDibs();
    switch (result) {
      case Success<List<LectureSmallView>, String>():
        _dibs.addAll(result.value.map((e) => e.id));
      case Error<List<LectureSmallView>, String>():
        print(result.error);
    }
  }

  Future<List<int>> reloadDibs() async {
    final result = await _dibsApiRepository.getDibs();
    switch (result) {
      case Success<List<LectureSmallView>, String>():
        _dibs.clear();
        _dibs.addAll(result.value.map((e) => e.id));
        return _dibs;
      case Error<List<LectureSmallView>, String>():
        print(result.error);
        return [];
    }
  }

  @override
  bool isDib(int id) {
    return _dibs.contains(id);
  }

  @override
  Future<void> addDib(int id) async {
    _dibs.add(id);

    final result = await _dibsApiRepository.addDib(id);

    if (result case Error<void,String>()) {
      _dibs.remove(id);
      print(result.error);
    }
  }

  @override
  Future<void> removeDib(int id) async {
    _dibs.remove(id);

    final result = await _dibsApiRepository.removeDib(id);

    if (result case Error<void,String>()) {
      _dibs.add(id);
      print(result.error);
    }
  }

  @override
  Future<void> toggleDib(int id) async {
    if (isDib(id)) {
      await removeDib(id);
    } else {
      await addDib(id);
    }
  }
}