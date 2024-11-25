import 'dart:typed_data';

import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/data/data_source/image_api.dart';

class ImageApiRepo {
  final ImageApi imageApi;

  ImageApiRepo(this.imageApi);

  Future<Result<String,String>> postImage(Uint8List imageData) async {
    return await imageApi.postImage(imageData);
  }
}