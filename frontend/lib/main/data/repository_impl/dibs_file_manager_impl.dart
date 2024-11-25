import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/data/data_source/file_manager_data_source.dart';
import 'package:tutor_platform/main/data/data_source/lecture_api_data_source.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_location_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_small_view.dart';
import 'package:tutor_platform/main/domain/repository/dibs_api_repository.dart';

class DibsFileManagerImpl implements DibsApiRepository {
  final FileManagerDataSource fileManager;
  final LectureApiDataSource lectureApiDataSource;

  DibsFileManagerImpl(this.fileManager, this.lectureApiDataSource);

  @override
  Future<Result<void, String>> addDib(int id) async {
    List<dynamic> unfurnishedDibList = await fileManager.readDibs();
    List<int> dibList = unfurnishedDibList.map((e) => e as int).toList();
    dibList.add(id);
    await fileManager.writeDibs(dibList);
    return Result.success(null);
  }

  @override
  Future<Result<List<LectureSmallView>, String>> getDibs() async {
    List<dynamic> unfurnishedDibList = await fileManager.readDibs();
    List<int> dibList = unfurnishedDibList.map((e) => e as int).toList();
    List<LectureSmallView> dibs = [];
    for (final id in dibList) {
      Result<LectureDto, String> result = await lectureApiDataSource.getLectureById(id);
      switch (result) {
        case Error<LectureDto, String>():
          return Result.error(result.error);
        case Success<LectureDto, String>():
          Map<String, dynamic> json = result.value.toJson();
          json['locations'] = json['locations'].map((e) => e.toJson()).toList();
          dibs.add(LectureSmallView.fromJson(json));
        default:
          return Result.error('Unknown error');
      }
    }
    return Result.success(dibs);
  }

  @override
  Future<Result<void, String>> removeDib(int id) async {
    List<dynamic> unfurnishedDibList = await fileManager.readDibs();
    List<int> dibList = unfurnishedDibList.map((e) => e as int).toList();
    dibList.remove(id);
    await fileManager.writeDibs(dibList);
    return Result.success(null);
  }


}