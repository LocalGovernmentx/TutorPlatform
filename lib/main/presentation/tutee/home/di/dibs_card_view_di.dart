import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/domain/use_case/dibs/dibs_lecture.dart';
import 'package:tutor_platform/main/domain/use_case/list_tile/card_view/get_dibs.dart';
import 'package:tutor_platform/main/domain/use_case/obtain_lecture.dart';
import 'package:tutor_platform/main/presentation/tutee/home/card_scroll_view.dart';
import 'package:tutor_platform/main/presentation/tutee/home/card_scroll_view_model.dart';
import 'package:tutor_platform/main/presentation/tutee/home/di/dibs_scroll_view_di.dart';

class DibsCardViewDi extends StatelessWidget {
  const DibsCardViewDi({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ProxyProvider2<DibsLectureUseCase, ObtainLecture, GetDibs>(
            update: (context, dibLec, getLec, previous) =>
                GetDibs(dibLec, getLec)),
        ChangeNotifierProvider<CardScrollViewModel>(
          create: (context) => CardScrollViewModel(
            context.read<GetDibs>(),
            context.read<DibsLectureUseCase>(),
          ),
        ),
      ],
      child: const CardScrollView(title: '찜한 강의', nextScreen: DibsScrollViewDi()),
    );
  }
}
