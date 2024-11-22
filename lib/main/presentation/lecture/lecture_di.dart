import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/domain/use_case/handle_ongoing_lecture.dart';
import 'package:tutor_platform/main/domain/use_case/obtain_lecture.dart';
import 'package:tutor_platform/main/presentation/lecture/lecture_view.dart';
import 'package:tutor_platform/main/presentation/lecture/lecture_view_model.dart';

class LectureDi extends StatelessWidget {
  final int lectureId;

  const LectureDi({super.key, required this.lectureId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) =>
            LectureViewModel(lectureId, context.read<ObtainLecture>(), context.read<HandleOngoingLecture>()),
        child: const LectureView());
  }
}
