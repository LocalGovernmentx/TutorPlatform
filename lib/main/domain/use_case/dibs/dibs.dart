abstract class DibsUseCase {
  Future<void> initDibs();
  bool isDib(int id);
  Future<void> addDib(int id);
  Future<void> removeDib(int id);
  Future<void> toggleDib(int id);
}