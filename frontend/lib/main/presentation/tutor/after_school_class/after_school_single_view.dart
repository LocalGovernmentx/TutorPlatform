import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/core/design/style.dart';
import 'package:tutor_platform/main/domain/model/dto/after_school_dto.dart';
import 'package:tutor_platform/main/presentation/components/appbar/common_app_bar.dart';
import 'package:tutor_platform/main/presentation/lecture/lecture_view_model.dart';
import 'package:tutor_platform/main/presentation/temp/lecture_images/obtain_image_strings.dart';
import 'package:tutor_platform/main/presentation/tutor/after_school_class/download_url.dart';

class AfterSchoolSingleView extends StatelessWidget {
  final AfterSchoolDto notice;

  const AfterSchoolSingleView({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    final String content = notice.content;

    return Scaffold(
      appBar: const CommonAppBar(
        title: '방과후 상세',
        actions: [],
      ),
      body: ListView(
        children: [
          Image.asset(
            obtainSchoolImage(notice.id),
            height: 250,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notice.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Text(notice.region),
                const SizedBox(height: 10),
                Text(content),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  downloadUrl(notice.filePath);
                },
                child: const Text('자료 다운로드'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
