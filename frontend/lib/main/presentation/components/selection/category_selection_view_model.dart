import 'package:flutter/cupertino.dart';
import 'package:tutor_platform/main/domain/model/dto/category_data.dart';
import 'package:tutor_platform/main/domain/use_case/handle_categories.dart';

class CategorySelectionViewModel extends ChangeNotifier {
  final HandleCategories _handleCategories;
  final List<CategoryData> categories = [];

  CategorySelectionViewModel(this._handleCategories) {
    _handleCategories.getCategories().then((value) {
      _generalCategoryStrings = _handleCategories.getGeneralCategories();
      notifyListeners();
    });
  }

  final Set<CategoryData> _chosenCategories = {};

  String? _generalCategory, _mediumCategory;

  bool openMediumCategory = false;
  bool skipMediumCategory = false;
  bool openSpecificCategory = false;

  List<String> _generalCategoryStrings = [];
  List<String?> _mediumCategoryStrings = [];
  List<CategoryData> _specificCategories = [];

  List<CategoryData> get chosenCategories => _chosenCategories.toList();

  bool isChosen(CategoryData category) => _chosenCategories.contains(category);

  // generalCategory
  String? get generalCategory => _generalCategory;

  List<String> get generalCategoryStrings => _generalCategoryStrings;

  void setCategory(CategoryData category) {
    _chosenCategories.clear();
    _chosenCategories.add(category);
    notifyListeners();
  }

  void setGeneralCategory(String category) {
    _generalCategory = category;

    _mediumCategory = null;
    openMediumCategory = false;
    openSpecificCategory = false;

    _mediumCategoryStrings = _handleCategories.getMediumCategories(category);
    _mediumCategoryStrings.remove(null);

    if (_mediumCategoryStrings.isEmpty) {
      skipMediumCategory = true;
      openSpecificCategory = true;

      _specificCategories = _handleCategories.getSpecificCategories(category, null);
    } else {
      skipMediumCategory = false;
      openMediumCategory = true;
    }
    notifyListeners();
  }

  // mediumCategory
  String? get mediumCategory => _mediumCategory;

  List<String?> get mediumCategoryStrings => _mediumCategoryStrings;

  void setMediumCategory(String category) {
    _mediumCategory = category;

    _specificCategories = _handleCategories.getSpecificCategories(_generalCategory!, _mediumCategory);

    openSpecificCategory = true;
    notifyListeners();
  }

  // specificCategory
  List<CategoryData> get specificCategories => _specificCategories;

  void toggleCategory(CategoryData category) {
    if (_chosenCategories.contains(category)) {
      _chosenCategories.remove(category);
    } else {
      _chosenCategories.add(category);
    }
    notifyListeners();
  }
}
