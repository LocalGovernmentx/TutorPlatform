import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_location_dto.dart';

part 'lecture_small_view.freezed.dart';
part 'lecture_small_view.g.dart';

@freezed
class LectureSmallView with _$LectureSmallView {
  const factory LectureSmallView({
    required int id,
    required String? nickname,
    required int categoryId,
    required String title,
    required String content,
    required int? score,
    required String? image,
    required List<LectureLocationDto> locations,
  }) = _LectureSmallView;

  factory LectureSmallView.fromJson(Map<String, dynamic> json) =>
      _$LectureSmallViewFromJson(json);
}
