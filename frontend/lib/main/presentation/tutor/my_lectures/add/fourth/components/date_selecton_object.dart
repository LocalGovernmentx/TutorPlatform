import 'package:tutor_platform/core/properties/lecture_information.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_time_dto.dart';

class DateSelectonObject {
  final WeekDay weekDay;

  DateSelectonObject({
    required this.weekDay,
  });

  bool startAM = true;
  bool endAM = true;

  int startTimeHour = 0;
  int startTimeMinute = 0;
  int endTimeHour = 0;
  int endTimeMinute = 0;

  bool validatedIncorrect = false;

  bool validate() {
    return toDateTime(startTimeHour, startTimeMinute, startAM)
        .isBefore(toDateTime(endTimeHour, endTimeMinute, endAM));
  }

  Map<String, dynamic> get lectureTimeDto => LectureTimeDto(
    id: 0,
    lectureId: 0,
    day: weekDay.index,
    startTime: startTime,
    endTime: endTime,
  ).toJson();

  get startTime => toDateTimeString(startTimeHour, startTimeMinute, startAM);

  get endTime => toDateTimeString(endTimeHour, endTimeMinute, endAM);

  List<Map<String, dynamic>> get startSelection => [
        {
          'value': ampmVariants[startAM ? 0 : 1],
          'variants': ampmVariants,
          'change': (Object? value) {
            startAM = (value as String) == '오전';
          },
        },
        {
          'value': startTimeHour,
          'variants': hourVariants,
          'change': (value) {
            startTimeHour = value as int;
          },
        },
        {
          'text': ':',
        },
        {
          'value': startTimeMinute,
          'variants': minuteVariants,
          'change': (value) {
            startTimeMinute = value as int;
          },
        },
      ];

  List<Map<String, dynamic>> get endSelection => [
        {
          'value': ampmVariants[endAM ? 0 : 1],
          'variants': ampmVariants,
          'change': (value) {
            endAM = (value as String) == '오전';
          },
        },
        {
          'value': endTimeHour,
          'variants': hourVariants,
          'change': (value) {
            endTimeHour = value as int;
          },
        },
        {
          'text': ':',
        },
        {
          'value': endTimeMinute,
          'variants': minuteVariants,
          'change': (value) {
            endTimeMinute = value as int;
          },
        },
      ];

  static get ampmVariants => ['오전', '오후'];

  static get hourVariants => List.generate(12, (index) => index);

  static get minuteVariants => List.generate(60, (index) => index);

  static toDateTime(int hour, int minute, bool am) {
    return DateTime(2021, 1, 1, am ? hour : hour + 12, minute);
  }

  static toDateTimeString(int hour, int minute, bool am) {
    return toDateTime(hour, minute, am)
        .toUtc()
        .toIso8601String();
  }
}
