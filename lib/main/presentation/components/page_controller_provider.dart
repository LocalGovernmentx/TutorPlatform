import 'package:flutter/material.dart';
import 'package:tutor_platform/main/presentation/components/bottom_navigation_bar/tutee/tutee_selected_screen.dart';
import 'package:tutor_platform/main/presentation/components/bottom_navigation_bar/tutor/tutor_selected_screen.dart';

class PageControllerProvider extends ChangeNotifier {
  final bool isTutor;

  PageControllerProvider(this.isTutor);

  final PageController _pageController = PageController(initialPage: 0);

  PageController get controller => _pageController;

  int get currentPage => _pageController.page?.round() ?? 0;

  Enum get currentScreen {
    if (isTutor) {
      return TutorSelectedScreen.values[currentPage];
    } else {
      return TuteeSelectedScreen.values[currentPage];
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void setPage(int index) {
    _pageController.jumpToPage(index);
    notifyListeners();
  }

  void setScreen(Enum screen) {
    final index = isTutor
        ? (screen as TutorSelectedScreen).index
        : (screen as TuteeSelectedScreen).index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }
}
