import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/domain/use_case/make_lecture.dart';
import 'package:tutor_platform/main/presentation/tutor/my_lectures/add/third/add_lecture_image_view_model.dart';

class AddLectureFinal extends StatefulWidget {
  final Map<String, dynamic> lectureInfo;
  final AddLectureImageViewModel imageVM;

  const AddLectureFinal({super.key, required this.lectureInfo, required this.imageVM});

  @override
  State<AddLectureFinal> createState() => _AddLectureFinalState();
}

class _AddLectureFinalState extends State<AddLectureFinal> {
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final viewModel = widget.imageVM;
      final makeLecture = context.read<MakeLecture>();
      viewModel.uploadLecture(widget.lectureInfo, makeLecture);
      _streamSubscription = viewModel.eventStream.listen((doneString) {
        if (doneString == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('강의 추가에 성공하였습니다.'),
            ),
          );
          Navigator.popUntil(context, (route) => route.isFirst);
        }
        else if (doneString == 'Server error') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('서버가 불안정합니다.'),
            ),
          );
          Navigator.pop(context);
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('강의 추가에 실패했습니다.'),
            ),
          );
          Navigator.pop(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
