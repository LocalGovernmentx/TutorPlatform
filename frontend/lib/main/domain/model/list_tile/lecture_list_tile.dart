import 'package:flutter/material.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_small_view.dart';
import 'package:tutor_platform/main/domain/model/list_tile/list_tile_objects.dart';
import 'package:tutor_platform/main/presentation/components/lecture_list/lecture_list_tile_view.dart';


class LectureListTile implements ListTileObjects {
  final int id;
  final String title;
  final String? mainImage;
  final String? tutorNickname;
  final int categoryId;
  final String content;
  final double? rating;
  final bool isBookmarked;

  const LectureListTile({
    required this.id,
    required this.title,
    required this.mainImage,
    required this.tutorNickname,
    required this.categoryId,
    required this.content,
    this.rating,
    required this.isBookmarked,
  });

  LectureListTile.fromLectureDto(LectureDto lectureDto, {isBookmarked, this.tutorNickname})
      : id = lectureDto.id,
        title = lectureDto.title,
        mainImage = lectureDto.mainImage,
        categoryId = lectureDto.categoryId,
        content = lectureDto.content,
        rating = lectureDto.avgRating,
        isBookmarked = isBookmarked ?? false;

  LectureListTile.fromLectureSmallView(LectureSmallView lectureSmallView, {isBookmarked})
      : id = lectureSmallView.id,
        title = lectureSmallView.title,
        mainImage = lectureSmallView.image,
        tutorNickname = lectureSmallView.nickname,
        categoryId = lectureSmallView.categoryId,
        content = lectureSmallView.content,
        rating = lectureSmallView.score?.toDouble(),
        isBookmarked = isBookmarked ?? false;

  @override
  Widget makeWidget() {
    return LectureListTileView(lectureListTile: this);
  }
}