import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutor_platform/main/domain/model/dto/pageable_object.dart';
import 'package:tutor_platform/main/domain/model/dto/sort_object.dart';

import 'simple_after_school_notice_response_dto.dart';

part 'page_simple_after_school_notice_response_dto.freezed.dart';
part 'page_simple_after_school_notice_response_dto.g.dart';

@freezed
class PageSimpleAfterSchoolNoticeResponseDto with _$PageSimpleAfterSchoolNoticeResponseDto {
  factory PageSimpleAfterSchoolNoticeResponseDto({
    required int totalPages,
    required int totalElements,
    required int size,
    required List<SimpleAfterSchoolNoticeResponseDto> content,
    required int number,
    required SortObject sort,
    required bool first,
    required bool last,
    required int numberOfElements,
    required PageableObject pageable,
    required bool empty,
  }) = _PageSimpleAfterSchoolNoticeResponseDto;

  factory PageSimpleAfterSchoolNoticeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PageSimpleAfterSchoolNoticeResponseDtoFromJson(json);
}
