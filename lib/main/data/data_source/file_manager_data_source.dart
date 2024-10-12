import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileManagerDataSource {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  
  Future<File> _writeFile(File file, List<dynamic> json) async {
    return await file.writeAsString(jsonEncode(json));
  }
  
  Future<List<dynamic>> _readFile(File file) async {
    if (!file.existsSync()) {
      return [];
    }
    try {
      String contents = await file.readAsString();
      return jsonDecode(contents);
    } catch (e, s) {
      print(e);
      print(s);

      throw Exception('e');
    }
  }

  // lecturefile
  Future<File> _lectureFile(int id) async {
    final path = await _localPath;
    return File('$path/$id/lecture.json');
  }

  Future<File> addUpdateLecture(int id, Map<String, dynamic> jsonLecture) async {
    final file = await _lectureFile(id);
    return await file.writeAsString(jsonEncode(jsonLecture));
  }

  Future<void> removeLecture(int id) async {
    final file = await _lectureFile(id);
    await file.delete();
  }

  Future<Map<String, dynamic>> getLecture(int id) async {
    final file = await _lectureFile(id);
    try {
      String contents = await file.readAsString();
      return jsonDecode(contents);
    } catch (e, s) {
      print(e);
      print(s);

      throw Exception('e');
    }
  }
  
  // category
  Future<File> get _categoryFile async {
    final path = await _localPath;
    return File('$path/category.json');
  }

  Future<File> writeCategory(List<dynamic> jsonCategory) async {
    final file = await _categoryFile;
    return await _writeFile(file, jsonCategory);
  }

  Future<List<dynamic>> readCategory() async {
    final file = await _categoryFile;
    return await _readFile(file);
  }
  
  // lecture
  Future<File> get _myLectureFile async {
    final path = await _localPath;
    return File('$path/myLecture.json');
  }

  Future<File> writeMyLecture(List<dynamic> jsonMyLecture) async {
    final file = await _myLectureFile;
    return await _writeFile(file, jsonMyLecture);
  }

  Future<List<dynamic>> readMyLecture() async {
    final file = await _myLectureFile;
    return await _readFile(file);
  }

  // dibs
  Future<File> get _dibsFile async {
    final path = await _localPath;
    return File('$path/dibs.json');
  }

  Future<File> writeDibs(List<dynamic> jsonDibs) async {
    final file = await _dibsFile;
    return await _writeFile(file, jsonDibs);
  }

  Future<List<dynamic>> readDibs() async {
    final file = await _dibsFile;
    return await _readFile(file);
  }
}
