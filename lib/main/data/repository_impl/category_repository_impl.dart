import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/data/data_source/category_api_data_source.dart';
import 'package:tutor_platform/main/data/data_source/file_manager_data_source.dart';
import 'package:tutor_platform/main/domain/model/dto/category_data.dart';
import 'package:tutor_platform/main/domain/repository/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final FileManagerDataSource _fileManagerDataSource;
  final CategoryApiDataSource _categoryApiDataSource;

  CategoryRepositoryImpl(
      this._fileManagerDataSource, this._categoryApiDataSource) {
    updateCategories();
  }

  Future<List<CategoryData>> _getCategoriesByApi() async {
    Result<List<CategoryData>, String> result =
        await _categoryApiDataSource.getCategories();
    switch (result) {
      case Success<List<CategoryData>, String>():
        return result.value;
      case Error<List<CategoryData>, String>():
        print(result.error);
        return [];
    }
  }

  @override
  Future<List<CategoryData>> getCategories() async {
    try {
      List<dynamic> unfurnishedCategories =
          await _fileManagerDataSource.readCategory();
      List<CategoryData> categories = [
        for (dynamic category in unfurnishedCategories)
          CategoryData.fromJson(category)
      ];
      updateCategories();
      return categories;
    } catch (e, s) {
      print(e);
      print(s);
      List<CategoryData> categories = await _updateCategories();
      return categories;
    }
  }

  Future<List<CategoryData>> _updateCategories() async {
    final List<CategoryData> categories = await _getCategoriesByApi();
    _fileManagerDataSource.writeCategory(categories);

    return categories;
  }

  @override
  Future<void> updateCategories() async {
    await _updateCategories();
  }

  @override
  Future<Result<CategoryData, String>> getCategoryById(int id) async {
    return await _categoryApiDataSource.getCategory(id);
  }
}
