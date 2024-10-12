import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/domain/model/list_tile/lecture_list_tile.dart';
import 'package:tutor_platform/main/presentation/lecture/lecture_di.dart';
import 'package:tutor_platform/main/presentation/tutee/home/card_scroll_view_model.dart';

class LectureCardView extends StatelessWidget {
  final LectureListTile lectureListTile;

  const LectureCardView({super.key, required this.lectureListTile});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CardScrollViewModel>();

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        width: 160,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LectureDi(lectureId: lectureListTile.id)));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  lectureListTile.mainImage ?? '',
                  width: 160,
                  height: 160,
                  errorBuilder: (context, stacktrace, stackTrace) => Image.asset(
                    'assets/images/default/lecture_default.png',
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      lectureListTile.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
                    child: SizedBox(
                      width: 17,
                      height: 17,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () async {
                          await viewModel.toggleDib(lectureListTile.id);
                        },
                        icon: viewModel.isDib(lectureListTile.id)
                            ? Image.asset('assets/icons/filled_heart.png',
                                width: 17)
                            : Image.asset('assets/icons/unfilled_heart.png',
                                width: 17),
                      ),
                    ),
                  ),
                ],
              ),
              Text(lectureListTile.tutorNickname ?? '사용자 이름'),
              Text(
                lectureListTile.content,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
