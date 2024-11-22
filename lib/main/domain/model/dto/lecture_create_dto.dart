import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_age_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_image_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_location_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_review_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_time_dto.dart';

part 'lecture_create_dto.freezed.dart';
part 'lecture_create_dto.g.dart';

@freezed
class LectureCreateDto with _$LectureCreateDto {
  const factory LectureCreateDto({
    required int categoryId,
    required String title,
    required String content,
    required bool activation,
    required int online,
    required int tuitionMaximum,
    required int tuitionMinimum,
    required int tuteeNumber,
    required int? gender,
    required int level,
    required List<LectureAgeDto> ages,
    @Default([]) List<LectureLocationDto> locations,
    required List<LectureReviewDto> reviews,
    required List<LectureTimeDto> times,
  }) = _LectureCreateDto;

  factory LectureCreateDto.fromJson(Map<String, dynamic> json) =>
      _$LectureCreateDtoFromJson(json);
}
