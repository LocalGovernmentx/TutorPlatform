import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/data/data_source/dibs_api_data_source.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_small_view.dart';
import 'package:tutor_platform/main/domain/repository/dibs_api_repository.dart';

class DibsApiRepositoryImpl implements DibsApiRepository {
  final DibsApiDataSource dibsApiDataSource;

  DibsApiRepositoryImpl(this.dibsApiDataSource);

  @override
  Future<Result<List<LectureSmallView>, String>> getDibs() async {
    return await dibsApiDataSource.getDibs();
  }

  @override
  Future<Result<void, String>> addDib(int id) async {
    return await dibsApiDataSource.addDib(id);
  }

  @override
  Future<Result<void, String>> removeDib(int id) async {
    return await dibsApiDataSource.removeDib(id);
  }
}