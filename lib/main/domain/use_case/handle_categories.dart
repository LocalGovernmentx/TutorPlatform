import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/domain/model/dto/category_data.dart';
import 'package:tutor_platform/main/domain/repository/category_repository.dart';

class HandleCategories {
  final CategoryRepository _categoryRepository;

  final List<CategoryData> categories = [];

  HandleCategories(this._categoryRepository);

  Future<List<CategoryData>> getCategories() async {
    List<CategoryData> result = await _categoryRepository.getCategories();
    categories.clear();
    categories.addAll(result);
    print('categories');
    print(categories);
    return categories;
  }

  Future<CategoryData> getCategoryById(int id) async {
    Result<CategoryData, String> result =
        await _categoryRepository.getCategoryById(id);
    switch (result) {
      case Success<CategoryData, String>():
        return result.value;
      case Error<CategoryData, String>():
        return const CategoryData(
            id: -1, generalCategory: '기타', specificCategory: '기타');
    }
  }

  List<String> getGeneralCategories() {
    List<String> result = categories.map((e) => e.generalCategory).toSet().toList();
    return result;
  }

  List<String?> getMediumCategories(String generalCategory) {
    return categories
        .where((element) => element.generalCategory == generalCategory)
        .map((e) => e.mediumCategory)
        .toSet()
        .toList();
  }

  List<CategoryData> getSpecificCategories(
      String generalCategory, String? mediumCategory) {
    return categories
        .where((element) =>
            element.generalCategory == generalCategory &&
            element.mediumCategory == mediumCategory)
        .toList();
  }
}
