import 'package:flutter/material.dart';
import 'package:tutor_platform/main/presentation/components/bottom_navigation_bar/tutee/tutee_selected_screen.dart';
import 'package:tutor_platform/main/presentation/temp/my_page_view.dart';
import 'package:tutor_platform/main/presentation/tutee/search/tutee_search_di.dart';

class TuteeNavigationBar extends StatelessWidget {
  final TuteeSelectedScreen currentScreen;
  final PageController controller;
  const TuteeNavigationBar({super.key, required this.currentScreen, required this.controller});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentScreen.index,
      onDestinationSelected: (index) {
        controller.jumpToPage(index);
      },
      destinations: [
        NavigationDestination(
          icon: Image.asset(
            'assets/icons/home.png',
            width: 26,
          ),
          label: '홈',
        ),
        // NavigationDestination(
        //   icon: Image.asset(
        //     'assets/icons/chat.png',
        //     width: 26,
        //   ),
        //   label: '대화',
        // ),
        NavigationDestination(
          icon: Image.asset(
            'assets/icons/magnifying_glass.png',
            width: 26,
          ),
          label: '검색하기',
        ),
        // NavigationDestination(
        //   icon: Image.asset(
        //     'assets/icons/question.png',
        //     width: 26,
        //   ),
        //   label: '문의',
        // ),
        NavigationDestination(
          icon: Image.asset(
            'assets/icons/user.png',
            width: 26,
          ),
          label: '마이페이지',
        ),
      ],
    );
  }
}
