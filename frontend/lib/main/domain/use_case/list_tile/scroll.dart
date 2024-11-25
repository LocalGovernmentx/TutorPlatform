import 'package:tutor_platform/main/domain/model/list_tile/list_tile_objects.dart';

abstract class ScrollUseCase<T extends ListTileObjects> {
  int get maxElements;
  Future<List<int>> initLoadIds();
  Future<List<int>> loadMoreIds();
  Future<T> loadId(int id);
  void set(Object value);
}