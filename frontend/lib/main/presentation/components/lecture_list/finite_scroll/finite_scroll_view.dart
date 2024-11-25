import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/presentation/components/lecture_list/scroll_view_model.dart';

class FiniteScrollView extends StatelessWidget {
  const FiniteScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollViewModel = context.watch<ScrollViewModel>();
    final lectures = scrollViewModel.elementWidgets;

    return Column(
      children: [
        Row(
          children: [
            const Text('Lecture List'),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        ListView.builder(
          itemCount: lectures.length + (scrollViewModel.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (scrollViewModel.isLoading && index == lectures.length) {
              return const Center(child: CircularProgressIndicator());
            }
            return lectures[index];
          },
        ),
      ],
    );
  }
}
