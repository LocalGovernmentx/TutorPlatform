import 'package:freezed_annotation/freezed_annotation.dart';

part 'lecture_age_dto.freezed.dart';
part 'lecture_age_dto.g.dart';

@freezed
class LectureAgeDto with _$LectureAgeDto {
  const factory LectureAgeDto({
    required int id,
    required int lectureId,
    required int age,
  }) = _LectureAgeDto;

  factory LectureAgeDto.fromJson(Map<String, dynamic> json) => _$LectureAgeDtoFromJson(json);
}