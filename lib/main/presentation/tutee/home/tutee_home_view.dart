import 'package:flutter/material.dart';
import 'package:tutor_platform/main/presentation/components/appbar/main_page_app_bar.dart';
import 'package:tutor_platform/main/presentation/tutee/home/di/dibs_card_view_di.dart';
import 'package:tutor_platform/main/presentation/tutee/home/di/home_ongoing_lectures_di.dart';

class TuteeHomeView extends StatelessWidget {
  const TuteeHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainPageAppBar(
        isTutor: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: ListView(
          children: const [
            HomeOngoingLecturesDi(),
            SizedBox(height: 20),
            DibsCardViewDi(),
          ],
        ),
      ),
    );
  }
}
