enum WeekDay {unused, monday, tuesday, wednesday, thursday, friday, saturday, sunday}

String WeekDayString(WeekDay day) {
  switch (day) {
    case WeekDay.monday:
      return '월';
    case WeekDay.tuesday:
      return '화';
    case WeekDay.wednesday:
      return '수';
    case WeekDay.thursday:
      return '목';
    case WeekDay.friday:
      return '금';
    case WeekDay.saturday:
      return '토';
    case WeekDay.sunday:
      return '일';
    default:
      return 'Unused';
  }
}

enum Difficulty {unused, easy, medium, hard}

enum OnOffline {both, online, offline}

enum StarRating {filled, halfFilled, unfilled}