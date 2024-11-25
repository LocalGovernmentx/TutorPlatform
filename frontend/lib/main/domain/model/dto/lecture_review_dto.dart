import 'package:freezed_annotation/freezed_annotation.dart';

part 'lecture_review_dto.freezed.dart';
part 'lecture_review_dto.g.dart';

@freezed
class LectureReviewDto with _$LectureReviewDto {
  const LectureReviewDto._();

  const factory LectureReviewDto({
    required int id,
    required int lectureId,
    required int tuteeId,
    required String content,
    required int score,
    required String reviewTime,
    required int online,
  }) = _LectureReviewDto;

  factory LectureReviewDto.fromJson(Map<String, dynamic> json) => _$LectureReviewDtoFromJson(json);

  static DateTime _parseTime(String time) {
    DateTime utcDateTime = DateTime.parse(time);

    // Convert to Korea Standard Time (UTC+9)
    DateTime kstDateTime = utcDateTime.add(const Duration(hours: 9));

    return kstDateTime;
  }

  DateTime get kstReviewTime => _parseTime(reviewTime);
}
