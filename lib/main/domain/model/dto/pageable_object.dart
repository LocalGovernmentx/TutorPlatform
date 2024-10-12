import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutor_platform/main/domain/model/dto/sort_object.dart';

part 'pageable_object.freezed.dart';
part 'pageable_object.g.dart';

@freezed
class PageableObject with _$PageableObject {
  const factory PageableObject({
    required int offset,
    required SortObject sort,
    required bool paged,
    required int pageSize,
    required bool unpaged,
  }) = _PageableObject;

  factory PageableObject.fromJson(Map<String, dynamic> json) => _$PageableObjectFromJson(json);
}
