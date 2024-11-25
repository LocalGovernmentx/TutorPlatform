import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/presentation/tutee/home/card_scroll_view_model.dart';
import 'package:tutor_platform/main/presentation/tutee/home/component/no_lecture_card.dart';

class CardScrollView extends StatelessWidget {
  final String title;
  final Widget nextScreen;

  const CardScrollView({super.key, required this.title, required this.nextScreen});

  @override
  Widget build(BuildContext context) {
    final CardScrollViewModel viewModel = context.watch<CardScrollViewModel>();

    return Column(
      children: [
        Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineLarge),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => nextScreen));
              },
              child: Text(
                '더보기 >',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 270,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              if (viewModel.cardViews.isEmpty) NoLectureCard(title: title),
              ...viewModel.cardViews,
              if (viewModel.isLoading)
                const SizedBox(
                  width: 160,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
