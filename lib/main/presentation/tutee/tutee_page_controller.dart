import 'package:flutter/material.dart';
import 'package:tutor_platform/main/presentation/components/bottom_navigation_bar/tutee/tutee_navigation_bar.dart';
import 'package:tutor_platform/main/presentation/components/bottom_navigation_bar/tutee/tutee_selected_screen.dart';
import 'package:tutor_platform/main/presentation/temp/my_page_view.dart';
import 'package:tutor_platform/main/presentation/tutee/home/tutee_home_view.dart';
import 'package:tutor_platform/main/presentation/tutee/search/tutee_search_di.dart';

class TuteePageController extends StatefulWidget {
  const TuteePageController({super.key});

  @override
  State<TuteePageController> createState() => _TuteePageControllerState();
}

class _TuteePageControllerState extends State<TuteePageController> {
  final _controller = PageController();
  int _selectedIndex = 0;

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          const TuteeHomeView(),
          TuteeSearchView(pageController: _controller,),
          MyPageView(pageController: _controller,),
        ],
      ),
      bottomNavigationBar: TuteeNavigationBar(
        controller: _controller,
        currentScreen: TuteeSelectedScreen.values[_selectedIndex],
      ),
    );
  }
}
