import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/domain/repository/lecture_api_repository.dart';
import 'package:tutor_platform/main/domain/use_case/dibs/dibs_lecture.dart';
import 'package:tutor_platform/main/domain/use_case/list_tile/my_lectures.dart';
import 'package:tutor_platform/main/domain/use_case/obtain_lecture.dart';
import 'package:tutor_platform/main/presentation/components/appbar/common_app_bar.dart';
import 'package:tutor_platform/main/presentation/components/bottom_navigation_bar/tutor/tutor_navigation_bar.dart';
import 'package:tutor_platform/main/presentation/components/lecture_list/scroll_view_model.dart';
import 'package:tutor_platform/main/presentation/components/page_controller_provider.dart';
import 'package:tutor_platform/main/presentation/tutor/my_lectures/add/add_lecture_first.dart';
import 'package:tutor_platform/main/presentation/tutor/my_lectures/tutor_my_lectures_view.dart';

class TutorMyLecturesDi extends StatelessWidget {
  const TutorMyLecturesDi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: '내 강의', actions: [],),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            MultiProvider(
              providers: [
                ProxyProvider2<LectureApiRepository, ObtainLecture, MyLectures>(
                  update: (context, apiRepo, obtainLecture, previous) =>
                      MyLectures(apiRepo, obtainLecture),

                ),
                ChangeNotifierProvider<ScrollViewModel>(
                  create: (context) => ScrollViewModel(
                    context.read<MyLectures>(),
                    context.read<DibsLectureUseCase>(),
                  ),
                )
              ],
              child: const TutorMyLecturesView(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddLectureFirst(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: TutorNavigationBar(
        controller: context.read<PageControllerProvider>().controller,
      ),
    );
  }
}
