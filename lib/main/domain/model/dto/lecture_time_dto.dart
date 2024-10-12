import 'package:freezed_annotation/freezed_annotation.dart';

part 'lecture_time_dto.freezed.dart';
part 'lecture_time_dto.g.dart';

@freezed
class LectureTimeDto with _$LectureTimeDto {
  const LectureTimeDto._();

  const factory LectureTimeDto({
    required int id,
    required int lectureId,
    required int day,
    required String startTime,
    required String endTime,
  }) = _LectureTimeDto;

  factory LectureTimeDto.fromJson(Map<String, dynamic> json) => _$LectureTimeDtoFromJson(json);

  static DateTime _parseTime(String time) {
    DateTime utcDateTime = DateTime.parse(time);

    // Convert to Korea Standard Time (UTC+9)
    DateTime kstDateTime = utcDateTime.add(const Duration(hours: 9));

    return kstDateTime;
  }

  DateTime get startDateTime => _parseTime(startTime);

  DateTime get endDateTime => _parseTime(endTime);
}
