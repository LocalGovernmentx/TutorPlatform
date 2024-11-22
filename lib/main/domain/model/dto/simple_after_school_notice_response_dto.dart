import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutor_platform/main/domain/model/list_tile/list_tile_objects.dart';
import 'package:tutor_platform/main/presentation/tutor/after_school_class/after_school_tile_view.dart';

part 'simple_after_school_notice_response_dto.freezed.dart';
part 'simple_after_school_notice_response_dto.g.dart';

@freezed
class SimpleAfterSchoolNoticeResponseDto with _$SimpleAfterSchoolNoticeResponseDto implements ListTileObjects {
  const SimpleAfterSchoolNoticeResponseDto._();

  const factory SimpleAfterSchoolNoticeResponseDto({
    required int id,
    required String title,
    required String content,
    required String region,
  }) = _SimpleAfterSchoolNoticeResponseDto;

  factory SimpleAfterSchoolNoticeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SimpleAfterSchoolNoticeResponseDtoFromJson(json);

  @override
  Widget makeWidget() {
    return AfterSchoolTileView(listTile: this);
  }
}
