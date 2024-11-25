import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_small_view.dart';

abstract class DibsApiRepository {
  Future<Result<List<LectureSmallView>, String>> getDibs();
  Future<Result<void, String>> addDib(int id);
  Future<Result<void, String>> removeDib(int id);
}