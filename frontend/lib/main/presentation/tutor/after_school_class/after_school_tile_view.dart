import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/domain/model/dto/after_school_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/simple_after_school_notice_response_dto.dart';
import 'package:tutor_platform/main/domain/repository/after_school_repository.dart';
import 'package:tutor_platform/main/domain/use_case/obtain_after_school.dart';
import 'package:tutor_platform/main/presentation/components/lecture_list/scroll_view_model.dart';
import 'package:tutor_platform/main/presentation/temp/lecture_images/obtain_image_strings.dart';
import 'package:tutor_platform/main/presentation/tutor/after_school_class/after_school_single_view.dart';

class AfterSchoolTileView extends StatelessWidget {
  final SimpleAfterSchoolNoticeResponseDto listTile;

  const AfterSchoolTileView({super.key, required this.listTile});

  @override
  Widget build(BuildContext context) {
    final scrollViewModel = context.watch<ScrollViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () async {
          final obtainAfterSchool = ObtainAfterSchool(context.read<AfterSchoolRepository>());
          final notice = await obtainAfterSchool(listTile.id);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AfterSchoolSingleView(notice: notice)));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                obtainSchoolImage(listTile.id),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(listTile.title,
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text(listTile.content,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  Row(
                    children: [
                      Text(
                        listTile.region,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
