import 'package:freezed_annotation/freezed_annotation.dart';

part 'lecture_image_dto.freezed.dart';
part 'lecture_image_dto.g.dart';

@freezed
class LectureImageDto with _$LectureImageDto {
  const factory LectureImageDto({
    required int id,
    required int lectureId,
    required String image,
    required bool mainImage,
  }) = _LectureImageDto;

  factory LectureImageDto.fromJson(Map<String, dynamic> json) => _$LectureImageDtoFromJson(json);

  static LectureImageDto empty() => const LectureImageDto(
    id: 0,
    lectureId: 0,
    image: '',
    mainImage: false,
  );
}