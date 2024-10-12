import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/core/design/colors.dart';
import 'package:tutor_platform/core/design/style.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_dto.dart';
import 'package:tutor_platform/main/domain/use_case/handling_user_info.dart';
import 'package:tutor_platform/main/presentation/components/appbar/common_app_bar.dart';
import 'package:tutor_platform/main/presentation/lecture/lecture_pictures.dart';
import 'package:tutor_platform/main/presentation/lecture/lecture_review.dart';
import 'package:tutor_platform/main/presentation/lecture/lecture_view_model.dart';

class LectureView extends StatelessWidget {
  const LectureView({super.key});

  @override
  Widget build(BuildContext context) {
    final lectureViewModel = context.watch<LectureViewModel>();

    if (lectureViewModel.isLoading) {
      return const Scaffold(
        appBar: CommonAppBar(
          title: '강의 상세',
          actions: [],
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isTutor = context.read<HandlingUserInfo>().isTutor;
    final LectureDto lecture = lectureViewModel.lecture;

    return Scaffold(
      appBar: const CommonAppBar(
        title: '강의 상세',
        actions: [],
      ),
      body: ListView(
        children: [
          Image.network(
            lecture.mainImage ?? '',
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/images/default/lecture_default.png',
              height: 250,
              fit: BoxFit.cover,
            ),
            height: 250,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lectureViewModel.tutorNickname),
                Text(
                  lecture.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Text(lecture.content),
                const SizedBox(height: 10),
                Row(children: [
                  Text(lectureViewModel.tuitionString,
                      style: Theme.of(context).textTheme.headlineLarge),
                  const Text(' 만원/1회'),
                ]),
                const SizedBox(height: 10),
                Text(
                  lectureViewModel.onOfflineString,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isTutor ? tutorPrimaryColor : tuteePrimaryColor,
                      ),
                ),
                Text(
                  lectureViewModel.ratingString,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            height: 8,
            color: uncheckedColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Text('강의 사진', style: Theme.of(context).textTheme.headlineSmall),
          ),
          const LecturePictures(),
          Container(
            height: 8,
            color: uncheckedColor,
          ),
          const LectureReview(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            OutlinedButton(
              onPressed: () {},
              style: unfilledOutlinedButtonStyle,
              child: Image.asset(
                'assets/icons/unfilled_heart.png',
                width: 30,
                color: isTutor ? tutorPrimaryColor : tuteePrimaryColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: uncheckedButtonStyle,
                child: const Text('수강하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
