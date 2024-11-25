import 'package:flutter/material.dart';
import 'package:tutor_platform/main/presentation/components/appbar/common_app_bar.dart';
import 'package:tutor_platform/main/presentation/components/bottom_navigation_bar/tutee/tutee_navigation_bar.dart';
import 'package:tutor_platform/main/presentation/components/bottom_navigation_bar/tutee/tutee_selected_screen.dart';
import 'package:tutor_platform/main/presentation/tutee/search/components/tutee_search_icon_button.dart';
import 'package:tutor_platform/main/presentation/tutee/search/components/tutee_search_tab_bar.dart';
import 'package:tutor_platform/main/presentation/tutee/search/infinite_scroll_di/lecture_search_di.dart';
import 'package:tutor_platform/main/presentation/tutee/search/tutee_search_lectures.dart';

class TuteeSearchView extends StatefulWidget {
  final PageController pageController;
  const TuteeSearchView({super.key, required this.pageController});

  @override
  State<TuteeSearchView> createState() => _TuteeSearchViewState();
}

class _TuteeSearchViewState extends State<TuteeSearchView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '검색하기',
        actions: const [
          // Padding(
          //   padding: EdgeInsets.only(right: 8.0),
          //   child: SearchIconButton(),
          // )
        ],
        // tabBar: TuteeSearchTabBar(tabController: _tabController),
        pageController: widget.pageController,
      ),
      body: const LectureSearchDi(),
      // TabBarView(
      //   controller: _tabController,
      //   children: const [
      //     LectureSearchDi(),
      //     Center(child: Text('coming soon')),
      //   ],
      // ),
    );
  }
}
