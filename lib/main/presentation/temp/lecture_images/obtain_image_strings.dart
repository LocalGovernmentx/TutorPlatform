String obtainLectureImage(int id) {
  int? imageId = [null, 1, 5, 6, 7, 8, null, null, null, 2, null, null, null, 3, 4, null, ][id % 16];
  if (imageId == null) {
    return 'assets/images/default/lecture_default.png';
  }
  return 'assets/images/lecture_images/lecture_image_$imageId.jpeg';
}

String obtainSchoolImage(int id) {
  int? imageId = [null, 1, 5, null, null, 6, 7, 8, 2, null, 3, 4, ][id % 12];
  if (imageId == null) {
    return 'assets/images/default/lecture_default.png';
  }
  return 'assets/images/school_images/school_image_$imageId.jpeg';
}