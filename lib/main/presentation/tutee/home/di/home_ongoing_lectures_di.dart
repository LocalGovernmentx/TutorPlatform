import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/domain/repository/lecture_api_repository.dart';
import 'package:tutor_platform/main/domain/use_case/dibs/dibs_lecture.dart';
import 'package:tutor_platform/main/domain/use_case/list_tile/card_view/get_ongoing_lecture.dart';
import 'package:tutor_platform/main/domain/use_case/obtain_lecture.dart';
import 'package:tutor_platform/main/presentation/tutee/home/card_scroll_view.dart';
import 'package:tutor_platform/main/presentation/tutee/home/card_scroll_view_model.dart';
import 'package:tutor_platform/main/presentation/tutee/home/di/ongoing_lectures_scroll_view_di.dart';

class HomeOngoingLecturesDi extends StatelessWidget {
  const HomeOngoingLecturesDi({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ProxyProvider2<LectureApiRepository, ObtainLecture, GetOngoingLecture>(
            update: (context, apiRepo, getLec, previous) =>
                GetOngoingLecture(apiRepo, getLec)),
        ChangeNotifierProvider<CardScrollViewModel>(
          create: (context) => CardScrollViewModel(
            context.read<GetOngoingLecture>(),
            context.read<DibsLectureUseCase>(),
          ),
        ),
      ],
      child: const CardScrollView(title: '진행 중인 강의', nextScreen: OngoingLecturesScrollViewDi()),
    );
  }
}
