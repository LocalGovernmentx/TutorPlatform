import 'package:freezed_annotation/freezed_annotation.dart';

part 'sort_object.freezed.dart';
part 'sort_object.g.dart';

@freezed
class SortObject with _$SortObject {
  const factory SortObject({
    required bool empty,
    required bool sorted,
    required bool unsorted,
  }) = _SortObject;

  factory SortObject.fromJson(Map<String, dynamic> json) => _$SortObjectFromJson(json);
}
