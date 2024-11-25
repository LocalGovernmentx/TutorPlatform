import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/domain/model/list_tile/lecture_list_tile.dart';
import 'package:tutor_platform/main/presentation/components/lecture_list/scroll_view_model.dart';
import 'package:tutor_platform/main/presentation/lecture/lecture_di.dart';
import 'package:tutor_platform/main/presentation/temp/lecture_images/obtain_image_strings.dart';

class LectureListTileView extends StatelessWidget {
  final LectureListTile lectureListTile;

  const LectureListTileView({super.key, required this.lectureListTile});

  @override
  Widget build(BuildContext context) {
    // final isTutor = context.read<HandlingUserInfo>().isTutor;
    final scrollViewModel = context.watch<ScrollViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LectureDi(lectureId: lectureListTile.id)));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                lectureListTile.mainImage ?? '',
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  obtainLectureImage(lectureListTile.id),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(lectureListTile.title,
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text(lectureListTile.content,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  // Text(
                  //     '${lectureListTile.tutorNickname} | ${lectureListTile.categoryId}',
                  //     style: Theme.of(context).textTheme.bodySmall),
                  Text(lectureListTile.tutorNickname ?? '사용자 이름'),
                  Row(
                    children: [
                      Text('★ ${lectureListTile.rating ?? '--'}',
                          style: Theme.of(context).textTheme.bodySmall),
                      // const SizedBox(width: 5),
                      // Text(
                      //   '대구 달서구',
                      //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      //       color: isTutor ? tutorPrimaryColor : tuteePrimaryColor),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: 17,
                height: 17,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    scrollViewModel.toggleDib(lectureListTile.id);
                  },
                  icon: scrollViewModel.isDib(lectureListTile.id)
                      ? Image.asset('assets/icons/filled_heart.png', width: 17)
                      : Image.asset('assets/icons/unfilled_heart.png',
                          width: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
