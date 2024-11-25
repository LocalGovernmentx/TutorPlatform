import 'package:flutter/cupertino.dart';
import 'package:tutor_platform/core/properties/lecture_information.dart';
import 'package:tutor_platform/main/presentation/tutor/my_lectures/add/fourth/components/date_selecton_object.dart';

class AddLectureDateViewModel extends ChangeNotifier {
  final List<DateSelectonObject> _dateSelections = [];
  String? errorMsg;

  List<DateSelectonObject> get dateSelections => _dateSelections;

  void addDateSelections(WeekDay weekDay) {
    _dateSelections.add(DateSelectonObject(weekDay: weekDay));
    _dateSelections.sort((a, b) => a.weekDay.index.compareTo(b.weekDay.index));
    notifyListeners();
  }

  void removeDateSelections(int index) {
    _dateSelections.removeAt(index);
    notifyListeners();
  }

  bool _hasError() {
    if (dateSelections.isEmpty) {
      errorMsg = '요일을 선택해주세요';
      notifyListeners();
      return true;
    }

    bool hasErrors = false;
    for (DateSelectonObject dateSelection in _dateSelections) {
      if (!dateSelection.validate()) {
        hasErrors = true;
      }
    }

    notifyListeners();
    return hasErrors;
  }

  bool finalize(Map<String, dynamic> lectureDto) {
    if (_hasError()) return false;

    List<Map<String, dynamic>> lectureTimes = [];

    for (DateSelectonObject dateSelection in _dateSelections) {
      lectureTimes.add(dateSelection.lectureTimeDto);
    }

    lectureDto['times'] = lectureTimes;

    print(lectureDto);

    return true;
  }
}