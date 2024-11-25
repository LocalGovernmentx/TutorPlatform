import 'package:flutter/material.dart';
import 'package:tutor_platform/core/design/colors.dart';

class NoLectureCard extends StatelessWidget {
  final String title;
  const NoLectureCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: uncheckedColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$title가',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                '없습니다.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
