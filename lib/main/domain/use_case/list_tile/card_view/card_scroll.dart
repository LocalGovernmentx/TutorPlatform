import 'package:tutor_platform/main/domain/model/list_tile/lecture_list_tile.dart';
import 'package:tutor_platform/main/domain/use_case/list_tile/scroll.dart';

abstract class CardScroll extends ScrollUseCase<LectureListTile> {
  Future<List<int>> getCardViewListIds();
}