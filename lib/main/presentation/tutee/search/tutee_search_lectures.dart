import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/core/design/colors.dart';
import 'package:tutor_platform/core/design/font.dart';
import 'package:tutor_platform/core/design/style.dart';
import 'package:tutor_platform/main/domain/use_case/handle_categories.dart';
import 'package:tutor_platform/main/presentation/components/lecture_list/infinite_scroll/infinite_scroll_view.dart';
import 'package:tutor_platform/main/presentation/components/lecture_list/scroll_view_model.dart';
import 'package:tutor_platform/main/presentation/components/selection/category_selection.dart';
import 'package:tutor_platform/main/presentation/components/selection/category_selection_view_model.dart';
import 'package:tutor_platform/main/presentation/tutee/search/selections/fee_selection.dart';
import 'package:tutor_platform/main/presentation/tutee/search/infinite_scroll_di/lecture_search_di.dart';
import 'package:tutor_platform/main/presentation/tutee/search/selections/onoffline_selection.dart';

class TuteeSearchLectures extends StatelessWidget {
  const TuteeSearchLectures({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScrollViewModel>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: Row(
              children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider<CategorySelectionViewModel>(
                                create: (context) => CategorySelectionViewModel(
                                    context.read<HandleCategories>()),
                                child: CategorySelection(scrollViewModel: viewModel),
                              ),
                            ),
                          );
                        },
                        child: const Text('분야 선택'))),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return FeeSelection(
                            viewModel: viewModel,
                          );
                        },
                      );
                    },
                    style: uncheckedSmallButtonStyle,
                    child: const Text('수업료'),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return OnofflineSelection(
                            viewModel: viewModel,
                          );
                        },
                      );
                    },
                    style: uncheckedSmallButtonStyle,
                    child: const Text('온/오프라인'),
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 10),
          // SizedBox(
          //   height: 50,
          //   width: double.infinity,
          //   child: OutlinedButton(
          //     onPressed: () {},
          //     child: const Text('내가 찾는 강의 등록하기'),
          //   ),
          // ),
          const SizedBox(height: 10),
          const InfiniteScrollView(),
        ],
      ),
    );
  }
}
