import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/domain/model/dto/category_data.dart';

abstract class CategoryRepository {
  Future<List<CategoryData>> getCategories();
  Future<void> updateCategories();
  Future<Result<CategoryData, String>> getCategoryById(int id);
}