import 'dart:io';

import 'package:flutter/services.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/data/repository_impl/image_api_repo.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_create_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_image_dto.dart';
import 'package:tutor_platform/main/domain/repository/lecture_api_repository.dart';

class MakeLecture {
  final LectureApiRepository _lectureApiRepository;
  final ImageApiRepo imageApiRepo;

  MakeLecture(this._lectureApiRepository, this.imageApiRepo);

  Future<String?> call(
      LectureCreateDto lecture, File? mainImage, List<File> subImages) async {

    Result<String, String> result = await _lectureApiRepository.makeLecture(lecture, mainImage, subImages);

    switch (result) {
      case Success<String, String>():
        print('success');
        return null;
      case Error<String, String>():
        print(result.error);
        return result.error;
    }
  }
}
