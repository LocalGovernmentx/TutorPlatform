import 'package:flutter/cupertino.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_review_dto.dart';
import 'package:tutor_platform/main/domain/use_case/handle_ongoing_lecture.dart';
import 'package:tutor_platform/main/domain/use_case/obtain_lecture.dart';

class LectureViewModel extends ChangeNotifier {
  final ObtainLecture _obtainLecture;
  final HandleOngoingLecture _handleOngoingLecture;

  LectureViewModel(lectureId, this._obtainLecture, this._handleOngoingLecture) {
    _isOngoing = _handleOngoingLecture.isOngoing(lectureId);
    _init(lectureId);
  }

  bool _isLoading = true;
  late LectureDto _lecture;
  late String _tutorNickName;
  late bool _isOngoing;

  void _init(int lectureId) async {
    _lecture = await _obtainLecture.getLecture(lectureId);
    _tutorNickName = _obtainLecture.tutorNickname(lectureId);
    _isLoading = false;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  LectureDto get lecture => _lecture;

  String get tutorNickname => _tutorNickName;

  bool get isOngoing => _isOngoing;

  String get tuitionString {
    if (_lecture.tuitionMinimum == _lecture.tuitionMaximum) {
      return _lecture.tuitionMinimum.toString();
    }
    return '${_lecture.tuitionMinimum / 10} ~ ${_lecture.tuitionMaximum / 10}';
  }

  String get onOfflineString {
    switch (_lecture.online) {
      case 0:
        return '오프라인';
      case 1:
        return '온라인';
      case 2:
        return '온라인, 오프라인';
      default:
        return '온라인';
    }
  }

  String get ratingString {
    if (_lecture.reviews!.isEmpty) {
      return '★ -- | 0개의 평가';
    }
    return '★ ${_lecture.avgRating} | ${_lecture.reviews!.length}개의 평가';
  }

  List<Widget> ratingImages(LectureReviewDto review) {
    final List<Widget> stars = [];
    for (var i = 0; i < review.score; i++) {
      stars.add(Image.asset('assets/images/reviews/filled_star.png', width: 16));
    }
    if (review.score * 2 % 2 == 1) {
      stars.add(Image.asset('assets/images/reviews/half_filled_star.png', width: 16));
    }
    for (var i = 0; i < 5 - review.score; i++) {
      stars.add(Image.asset('assets/images/reviews/unfilled_star.png', width: 16));
    }
    return stars;
  }

  void toggleOngoing() async {
    final result = await _handleOngoingLecture.toggleOngoing(_lecture.id);
    if (result) {
      _isOngoing = !_isOngoing;
      notifyListeners();
    }
  }
}
