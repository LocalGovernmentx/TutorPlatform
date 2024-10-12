import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/domain/repository/lecture_api_repository.dart';
import 'package:tutor_platform/main/domain/use_case/dibs/dibs_lecture.dart';
import 'package:tutor_platform/main/domain/use_case/list_tile/lecture_paging.dart';
import 'package:tutor_platform/main/domain/use_case/obtain_lecture.dart';
import 'package:tutor_platform/main/presentation/components/lecture_list/infinite_scroll/infinite_scroll_view.dart';
import 'package:tutor_platform/main/presentation/components/lecture_list/scroll_view_model.dart';
import 'package:tutor_platform/main/presentation/tutee/search/tutee_search_lectures.dart';

class LectureSearchDi extends StatelessWidget {
  const LectureSearchDi({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ProxyProvider2<LectureApiRepository, ObtainLecture, LecturePaging>(
          update: (context, apiRepo, obtainLecture, previous) =>
              LecturePaging(apiRepo, obtainLecture),
        ),
        ChangeNotifierProvider<ScrollViewModel>(
          create: (context) => ScrollViewModel(
            context.read<LecturePaging>(),
            context.read<DibsLectureUseCase>(),
          ),
        ),
      ],
      child: const TuteeSearchLectures(),
    );
  }
}
