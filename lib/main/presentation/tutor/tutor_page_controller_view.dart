import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/presentation/components/bottom_navigation_bar/tutor/tutor_navigation_bar.dart';
import 'package:tutor_platform/main/presentation/components/bottom_navigation_bar/tutor/tutor_selected_screen.dart';
import 'package:tutor_platform/main/presentation/components/page_controller_provider.dart';
import 'package:tutor_platform/main/presentation/temp/my_page_view.dart';
import 'package:tutor_platform/main/presentation/tutor/after_school_class/tutor_after_school_di.dart';
import 'package:tutor_platform/main/presentation/tutor/tutor_home_view.dart';

class TutorPageControllerView extends StatelessWidget {
  const TutorPageControllerView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PageControllerProvider>();

    return Scaffold(
      body: PageView(
        controller: provider.controller,
        onPageChanged: (index) {
          provider.setPage(index);
        },
        children: [
          const TutorHomeView(),
          TutorAfterSchoolDi(pageController: provider.controller,),
          MyPageView(
            pageController: provider.controller,
          ),
        ],
      ),
      bottomNavigationBar: TutorNavigationBar(
        controller: provider.controller,
      ),
    );
  }
}
