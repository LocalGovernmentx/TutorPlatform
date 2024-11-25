import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_small_view.dart';
import 'package:tutor_platform/main/domain/model/dto/pageable_object.dart';
import 'package:tutor_platform/main/domain/model/dto/sort_object.dart';

part 'page_lecture_dto.freezed.dart';
part 'page_lecture_dto.g.dart';

@freezed
class PageLectureDto with _$PageLectureDto {
  const factory PageLectureDto({
    required int totalPages,
    required int totalElements,
    required int size,
    required List<LectureSmallView> content,
    required int number,
    required SortObject sort,
    required PageableObject pageable,
    required int numberOfElements,
    required bool first,
    required bool last,
    required bool empty,
  }) = _PageLectureDto;

  factory PageLectureDto.fromJson(Map<String, dynamic> json) => _$PageLectureDtoFromJson(json);
}
