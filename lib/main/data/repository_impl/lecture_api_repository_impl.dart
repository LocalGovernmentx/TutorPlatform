import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/data/data_source/file_manager_data_source.dart';
import 'package:tutor_platform/main/data/data_source/lecture_api_data_source.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/page_lecture_dto.dart';
import 'package:tutor_platform/main/domain/repository/lecture_api_repository.dart';

class LectureApiRepositoryImpl implements LectureApiRepository {
  final LectureApiDataSource lectureApiDataSource;
  final FileManagerDataSource fileManager;

  LectureApiRepositoryImpl(this.lectureApiDataSource, this.fileManager);

  @override
  Future<Result<PageLectureDto,String>> getLectures(int page, int size, List<int> categoryId, int onOffline, int? maxPrice) async {
    return await lectureApiDataSource.getLectureWithFiltering(page, size, categoryId, onOffline, maxPrice);
  }

  @override
  Future<Result<LectureDto, String>> getLectureById(int id) async {
    return await lectureApiDataSource.getLectureById(id);
  }

  @override
  Future<Result<List<LectureDto>, String>> getOngoingLectures(int id, int size) async {
    return await lectureApiDataSource.getOngoingLectures(id, size);
  }

  @override
  Future<Result<List<int>, String>> getMyLectureIds() async {
    List<dynamic> unfurnishedList = await fileManager.readMyLecture();
    List<int> lectureList = unfurnishedList.map((e) => e as int).toList();
    return Result.success(lectureList);
  }
}