import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/domain/use_case/dibs/dibs_lecture.dart';
import 'package:tutor_platform/main/domain/use_case/list_tile/card_view/get_dibs.dart';
import 'package:tutor_platform/main/domain/use_case/obtain_lecture.dart';
import 'package:tutor_platform/main/presentation/components/appbar/common_app_bar.dart';
import 'package:tutor_platform/main/presentation/components/lecture_list/infinite_scroll/infinite_scroll_view.dart';
import 'package:tutor_platform/main/presentation/components/lecture_list/scroll_view_model.dart';

class DibsScrollViewDi extends StatelessWidget {
  const DibsScrollViewDi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: '찜한 강의', actions: [],),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            MultiProvider(
              providers: [
                ProxyProvider2<DibsLectureUseCase, ObtainLecture, GetDibs>(
                    update: (context, dibLec, getLec, previous) =>
                        GetDibs(dibLec, getLec)),
                ChangeNotifierProvider<ScrollViewModel>(
                  create: (context) => ScrollViewModel(
                    context.read<GetDibs>(),
                    context.read<DibsLectureUseCase>(),
                  ),
                ),
              ],
              child: const InfiniteScrollView(),
            ),
          ],
        ),
      ),
    );
  }
}
