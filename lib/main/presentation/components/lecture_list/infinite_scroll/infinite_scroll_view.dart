import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/core/design/colors.dart';
import 'package:tutor_platform/core/design/font.dart';
import 'package:tutor_platform/main/presentation/components/lecture_list/scroll_view_model.dart';

class InfiniteScrollView extends StatefulWidget {
  const InfiniteScrollView({super.key});

  @override
  State<InfiniteScrollView> createState() => _InfiniteScrollViewState();
}

class _InfiniteScrollViewState extends State<InfiniteScrollView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final scrollViewModel = context.read<ScrollViewModel>();
      if (scrollViewModel.noMoreLoading) {
        return;
      }
      if (!scrollViewModel.isLoading &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        scrollViewModel.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrollViewModel = context.watch<ScrollViewModel>();
    final elementWidgets = scrollViewModel.elementWidgets;

    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Text('추천 순', style: hintTextStyle),
              Image.asset('assets/icons/arrange_arrow.png', width: 24),
              const Spacer(),
              Text('총 ${scrollViewModel.maxElements}개',
                  style: hintTextStyle.copyWith(color: tuteePrimaryColor)),
            ],
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount:
                  elementWidgets.length + (scrollViewModel.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (scrollViewModel.isLoading &&
                    index == elementWidgets.length) {
                  return const SizedBox(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return elementWidgets[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}
