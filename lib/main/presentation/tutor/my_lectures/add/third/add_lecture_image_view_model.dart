import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor_platform/core/design/colors.dart';

class AddLectureImageViewModel extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  File? _mainImage;
  final List<File> _subImages = [];

  File? get mainImage => _mainImage;

  List<File> get subImages => _subImages;

  Widget get mainImageWidget {
    if (_mainImage == null) {
      return Container(
        color: uncheckedBorderColor,
        child: const Icon(Icons.add),
      );
    } else {
      return Image.file(
        _mainImage!,
        fit: BoxFit.cover,
      );
    }
  }

  List<Widget> get subImageWidgets {
    return _subImages
        .map(
          (image) => Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 100,
              width: 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    image,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () {
                        removeSubImage(image);
                      },
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  Future<File?> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return null;

    return File(pickedImage.path);
  }

  Future<void> pickMainImage() async {
    final File? image = await _pickImage();
    if (image != null) {
      _mainImage = image;
      notifyListeners();
    }
  }

  Future<void> addSubImages() async {
    final File? image = await _pickImage();
    if (image != null) {
      _subImages.add(image);
      notifyListeners();
    }
  }

  Future<void> removeSubImage(File elem) async {
    _subImages.remove(elem);
    notifyListeners();
  }
}
