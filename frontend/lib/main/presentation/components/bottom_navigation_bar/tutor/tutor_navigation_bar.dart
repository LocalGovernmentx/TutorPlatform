import 'package:flutter/material.dart';
import 'package:tutor_platform/main/presentation/components/bottom_navigation_bar/tutor/tutor_selected_screen.dart';

class TutorNavigationBar extends StatelessWidget {
  final TutorSelectedScreen? currentScreen;
  final PageController controller;

  const TutorNavigationBar({super.key, this.currentScreen, required this.controller});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentScreen?.index ?? controller.page?.round() ?? 0,
      onDestinationSelected: (index) {
        Navigator.popUntil(context, (route) => route.isFirst);
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
        NavigationDestination(
          icon: Image.asset(
            'assets/icons/docs.png',
            width: 26,
          ),
          label: '방과후',
        ),
        // NavigationDestination(
        //   icon: Image.asset(
        //     'assets/icons/book.png',
        //     width: 26,
        //   ),
        //   label: '채팅',
        // ),
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
