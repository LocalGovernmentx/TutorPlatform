import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/presentation/lecture/lecture_view_model.dart';

class LecturePictures extends StatelessWidget {
  const LecturePictures({super.key});

  @override
  Widget build(BuildContext context) {
    final lecture = context.watch<LectureViewModel>().lecture;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            if (lecture.subImages.isEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/default/lecture_default.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            for (final image in lecture.subImages)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    image,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset(
                      'assets/images/default/lecture_default.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
