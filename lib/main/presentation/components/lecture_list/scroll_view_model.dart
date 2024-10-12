import 'package:flutter/cupertino.dart';
import 'package:tutor_platform/main/domain/model/dto/category_data.dart';
import 'package:tutor_platform/main/domain/model/list_tile/list_tile_objects.dart';
import 'package:tutor_platform/main/domain/use_case/dibs/dibs.dart';
import 'package:tutor_platform/main/domain/use_case/list_tile/scroll.dart';

class ScrollViewModel extends ChangeNotifier {
  final ScrollUseCase<ListTileObjects> _scrollUseCase;
  final DibsUseCase _dibsUseCase;

  ScrollViewModel(this._scrollUseCase, this._dibsUseCase) {
    _initLoad();
  }

  final List<int> _elementIds = [];
  final List<Widget> _elementWidgets = [];
  bool _isLoading = false;
  int _maxElements = -1;

  int get maxElements => _maxElements;

  List<Widget> get elementWidgets => _elementWidgets;

  bool get isLoading => _isLoading;

  bool get noMoreLoading => _elementIds.length == _maxElements;

  Future<void> _loadListTiles(List<int> ids) async {
    for (final id in ids) {
      ListTileObjects listTile = await _scrollUseCase.loadId(id);
      _elementWidgets.add(listTile.makeWidget());
      notifyListeners();
    }
  }

  void _initLoad() async {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }

    List<int> initLoads = await _scrollUseCase.initLoadIds();
    _elementIds.addAll(initLoads);

    _maxElements = _scrollUseCase.maxElements;

    await _loadListTiles(initLoads);

    _isLoading = false;
    notifyListeners();
  }

  void loadMore() async {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }

    List<int> moreIds = await _scrollUseCase.loadMoreIds();
    _elementIds.addAll(moreIds);

    await _loadListTiles(moreIds);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addDib(int id) async {
    await _dibsUseCase.addDib(id);
    notifyListeners();
  }

  Future<void> removeDib(int id) async {
    await _dibsUseCase.removeDib(id);
    notifyListeners();
  }

  bool isDib(int id) {
    return _dibsUseCase.isDib(id);
  }

  Future<void> toggleDib(int id) async {
    await _dibsUseCase.toggleDib(id);
    notifyListeners();
  }

  List<CategoryData> categories = [];

  void set(Object object) {
    _scrollUseCase.set(object);
    if (object is List<CategoryData>) {
      categories = object;
    }
    _elementIds.clear();
    _elementWidgets.clear();
    _maxElements = -1;
    _initLoad();
  }
}
