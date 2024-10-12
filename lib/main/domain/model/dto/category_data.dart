import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_data.freezed.dart';
part 'category_data.g.dart';

@freezed
class CategoryData with _$CategoryData {
  const factory CategoryData({
    required int id,
    required String generalCategory,
    String? mediumCategory,
    required String specificCategory,
  }) = _CategoryData;

  factory CategoryData.fromJson(Map<String, dynamic> json) =>
      _$CategoryDataFromJson(json);
}
