import 'package:flutter/material.dart';
import 'package:tutor_platform/main/domain/use_case/dibs/dibs_lecture.dart';
import 'package:tutor_platform/main/domain/use_case/list_tile/card_view/card_scroll.dart';
import 'package:tutor_platform/main/domain/use_case/list_tile/card_view/get_ongoing_lecture.dart';
import 'package:tutor_platform/main/presentation/tutee/home/component/lecture_card_view.dart';

class CardScrollViewModel extends ChangeNotifier{
  final CardScroll _cardScroll;
  final DibsLectureUseCase _dibsLectureUseCase;

  CardScrollViewModel(this._cardScroll, this._dibsLectureUseCase) {
    print(_cardScroll);
    _initLoad();
  }

  bool _isLoading = true;
  final List<int> _ids = [];
  final List<Widget> _cardViews = [];

  bool get isLoading => _isLoading;

  List<Widget> get cardViews => _cardViews;

  Future<void> _initLoad() async {
    _ids.addAll(await _cardScroll.getCardViewListIds());
    _isLoading = false;
    _loadCardViews();
    notifyListeners();
  }

  Future<void> _loadCardViews() async {
    _isLoading = true;
    notifyListeners();

    for (final id in _ids) {
      final lecture = await _cardScroll.loadId(id);
      _cardViews.add(LectureCardView(lectureListTile: lecture));
      notifyListeners();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleDib(int id) async {
    _dibsLectureUseCase.toggleDib(id);
    notifyListeners();
  }

  bool isDib(int id) {
    return _dibsLectureUseCase.isDib(id);
  }
}
