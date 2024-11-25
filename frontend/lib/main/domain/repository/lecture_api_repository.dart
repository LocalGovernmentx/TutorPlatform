import 'dart:io';

import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_create_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/page_lecture_dto.dart';

abstract class LectureApiRepository {
  Future<Result<PageLectureDto, String>> getLectures(int page, int size, List<int> categoryId, int onOffline, int? maxPrice);
  Future<Result<LectureDto, String>> getLectureById(int id);
  Future<Result<List<LectureDto>, String>> getOngoingLectures(int id, int size);
  Future<Result<List<int>, String>> getMyLectureIds();
  Future<Result<void, String>> toggleOngoing(int id);
  Future<Result<String, String>> makeLecture(LectureCreateDto lecture, File? mainImage, List<File> subImages);
}