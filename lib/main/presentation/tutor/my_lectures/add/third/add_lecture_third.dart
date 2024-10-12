import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/presentation/components/appbar/common_app_bar.dart';
import 'package:tutor_platform/main/presentation/tutor/my_lectures/add/fourth/add_lecture_date_view_model.dart';
import 'package:tutor_platform/main/presentation/tutor/my_lectures/add/fourth/add_lecture_fourth.dart';
import 'package:tutor_platform/main/presentation/tutor/my_lectures/add/third/add_lecture_image_view_model.dart';

class AddLectureThird extends StatelessWidget {
  final Map<String, dynamic> lectureInfo;

  const AddLectureThird({super.key, required this.lectureInfo});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddLectureImageViewModel>();

    return Scaffold(
      appBar: const CommonAppBar(title: '강의 추가', actions: [Text('3/4 단계')]),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('대표 사진'),
                TextButton(
                  child: const Text(
                    '변경',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                  ),
                  onPressed: () {
                    viewModel.pickMainImage();
                  },
                )
              ],
            ),
            const SizedBox(height: 7),
            SizedBox(
              height: 250,
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  viewModel.pickMainImage();
                },
                child: viewModel.mainImageWidget,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...viewModel.subImageWidgets,
                  GestureDetector(
                    onTap: () {
                      viewModel.addSubImages();
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider(create: (context) => context.read<AddLectureImageViewModel>()),
                      ChangeNotifierProvider(create: (context) => AddLectureDateViewModel()),
                    ],
                    child: AddLectureFourth(lectureInfo: lectureInfo),
                  ),
                ),
              );
            },
            child: const Text('다음단계'),
          ),
        ),
      ),
    );
  }
}
