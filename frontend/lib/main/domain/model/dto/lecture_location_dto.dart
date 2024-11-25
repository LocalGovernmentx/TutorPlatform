import 'package:freezed_annotation/freezed_annotation.dart';

part 'lecture_location_dto.freezed.dart';
part 'lecture_location_dto.g.dart';

@freezed
class LectureLocationDto with _$LectureLocationDto {
  const factory LectureLocationDto({
    required int locationId,
    required int lectureId,
  }) = _LectureLocationDto;

  factory LectureLocationDto.fromJson(Map<String, dynamic> json) => _$LectureLocationDtoFromJson(json);
}
