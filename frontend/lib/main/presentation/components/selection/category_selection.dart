import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/domain/model/dto/category_data.dart';
import 'package:tutor_platform/main/presentation/components/lecture_list/scroll_view_model.dart';
import 'package:tutor_platform/main/presentation/components/selection/category_selection_view_model.dart';

class CategorySelection extends StatelessWidget {
  final Function changeCategory;
  final bool canSelectMultiple;

  const CategorySelection({super.key, required this.changeCategory, this.canSelectMultiple = true});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CategorySelectionViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('튜터링 분야 선택'),
        centerTitle: true,
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Column(
        children: [
          Wrap(
            spacing: 4,
            runSpacing: -4,
            children: [
              for (final category in viewModel.chosenCategories)
                Chip(
                  label: Text(category.specificCategory),
                  onDeleted: () {
                    viewModel.toggleCategory(category);
                  },
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  side:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  deleteIconColor: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey[100],
                    child: ListView(
                      children: viewModel.generalCategoryStrings
                          .map(
                            (categoryStr) => Container(
                              color: viewModel.generalCategory == categoryStr
                                  ? Colors.white
                                  : null,
                              child: ListTile(
                                title: Text(categoryStr),
                                onTap: () {
                                  viewModel.setGeneralCategory(categoryStr);
                                },
                                selected:
                                    viewModel.generalCategory == categoryStr,
                                selectedColor: Colors.black,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                if (viewModel.openMediumCategory)
                  Expanded(
                    child: ListView(
                      children: [
                        for (final categoryStr
                            in viewModel.mediumCategoryStrings)
                          ListTile(
                            title: Text(categoryStr!),
                            onTap: () {
                              viewModel.setMediumCategory(categoryStr);
                            },
                            selected: viewModel.mediumCategory == categoryStr,
                            selectedColor: Colors.black,
                          ),
                      ],
                    ),
                  ),
                Expanded(
                  flex: viewModel.openMediumCategory ? 1 : 2,
                  child: viewModel.openSpecificCategory
                      ? ListView(
                          children: [
                            for (CategoryData category
                                in viewModel.specificCategories)
                              ListTile(
                                title: Text(category.specificCategory),
                                onTap: () {
                                  if (canSelectMultiple) {
                                    viewModel.toggleCategory(category);
                                  } else {
                                    viewModel.setCategory(category);
                                  }
                                },
                                selected: viewModel.isChosen(category),
                                selectedColor: Colors.black,
                                trailing: viewModel.isChosen(category)
                                    ? Icon(Icons.check,
                                        color: Theme.of(context).primaryColor)
                                    : const Icon(Icons.check),
                              ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  changeCategory(viewModel.chosenCategories);
                  Navigator.pop(context);
                },
                child: const Text('선택 완료'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
