import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutor_platform/core/properties/lecture_information.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_age_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_image_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_location_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_review_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_time_dto.dart';

part 'lecture_dto.freezed.dart';

part 'lecture_dto.g.dart';

@freezed
class LectureDto with _$LectureDto {
  const LectureDto._();

  const factory LectureDto({
    required int id,
    required int tutorId,
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
    required List<LectureAgeDto>? ages,
    required List<LectureImageDto>? images,
    @Default([]) List<LectureLocationDto>? locations,
    required List<LectureReviewDto>? reviews,
    required List<LectureTimeDto>? times,
  }) = _LectureDto;

  factory LectureDto.fromJson(Map<String, dynamic> json) =>
      _$LectureDtoFromJson(json);

  double? get avgRating => reviews!.isEmpty
      ? null
      : reviews!.map((e) => e.score).reduce((a, b) => a + b) / reviews!.length;

  String? get mainImage => images!.firstWhere((e) => e.mainImage, orElse: () => images!.isEmpty ? LectureImageDto.empty() : images![0]).image;

  List<String> get subImages => images!.where((e) => !e.mainImage).map((e) => e.image).toList();

  OnOffline get onlineOrOffline => OnOffline.values[online];
}
