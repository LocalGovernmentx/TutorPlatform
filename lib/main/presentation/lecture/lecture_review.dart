import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_review_dto.dart';
import 'package:tutor_platform/main/presentation/lecture/lecture_view_model.dart';

class LectureReview extends StatelessWidget {
  const LectureReview({super.key});

  @override
  Widget build(BuildContext context) {
    final lectureViewModel = context.watch<LectureViewModel>();
    final List<LectureReviewDto> reviews = lectureViewModel.lecture.reviews!;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('리뷰', style: Theme.of(context).textTheme.headlineSmall),
          // Row(
          //   children: [
          //     Column(
          //       children: [],
          //     ),
          //     Column(
          //       children: [],
          //     ),
          //   ],
          // ),
          const SizedBox(height: 10),
          for (final review in reviews) ...[
            Row(
              children: [
                ClipOval(
                  child: Image.network(
                    '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/default/default_profile_image.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('사용자 이름', style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        ...lectureViewModel.ratingImages(review),
                        const SizedBox(width: 10),
                        Text(DateFormat('yyyy.MM.dd')
                            .format(review.kstReviewTime)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(review.content),
                  ],
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}
