import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/models/user_info.dart';
import 'package:tutor_platform/core/properties/backend_information.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/page_lecture_dto.dart';

class LectureApiDataSource {
  final http.Client client;
  final JwtToken jwtToken;
  final UserInfo userInfo;
  final String authorization;

  LectureApiDataSource(this.client, this.jwtToken, this.userInfo)
      : authorization = jwtToken.accessToken;

  static const baseUrl = '$backendBaseUrl/lectures';

  Future<List<LectureDto>> getAllLectures() async {
    final url = Uri.parse(baseUrl);
    final headers = {
      'Authorization': authorization,
    };

    http.Response response = await client.get(url, headers: headers);

    if (response.statusCode ~/ 100 == 2) {
      final List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((e) => LectureDto.fromJson(e)).where((e) =>
      e.tutorId == userInfo.id).toList();
    }

    throw Exception('Failed to load lectures');
  }

  Future<Result<PageLectureDto, String>> getLectures(int page, int size) async {
    final url = Uri.parse('$baseUrl/paging?page=$page&size=$page&sort=id');
    final headers = {
      'Authorization': authorization,
    };

    late http.Response response;
    try {
      response = await client.get(url, headers: headers);
    } catch (e) {
      return Result.error(e.toString());
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(
          utf8.decode(response.bodyBytes));
      return Result.success(PageLectureDto.fromJson(body));
    }

    return Result.error('Failed to load lectures');
  }

  Future<Result<PageLectureDto, String>> getLectureWithFiltering(int page,
      int size, List<int> categoryId, int onOffline, int? maxPrice) async {
    String urlStr = '$baseUrl/list?page=$page&size=$size&sort=id';

    if (onOffline > 0) {
      urlStr += '&online=$onOffline';
    }
    if (maxPrice != null && maxPrice > 0) {
      print(maxPrice);
      urlStr += '&tuitionMaximum=${maxPrice * 10}';
    }
    for (final id in categoryId) {
      urlStr += '&categoryId=$id';
    }

    print(urlStr);

    final url = Uri.parse(urlStr);
    final headers = {
      'Authorization': authorization,
    };

    late http.Response response;
    try {
      response = await client.get(url, headers: headers);
    } catch (e, s) {
      print(e);
      print(s);
      return Result.error(e.toString());
    }
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return Result.success(PageLectureDto.fromJson(body));
    }

    print(response.body);
    print(response.statusCode);

    return Result.error('Failed to load lectures');
  }

  Future<Result<LectureDto, String>> getLectureById(int id) async {
    final url = Uri.parse('$baseUrl/$id');
    final headers = {
      'Authorization': authorization,
    };

    try {
      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        final body = json.decode(utf8.decode(response.bodyBytes));
        return Result.success(LectureDto.fromJson(body));
      }
      return Result.error('Failed to load lecture');
    } catch (e, stackTrace) {
      print(stackTrace);
      return Result.error(e.toString());
    }
  }

  Future<Result<List<LectureDto>, String>> getOngoingLectures(int id,
      int size) async {
    final url = Uri.parse('$baseUrl/ongoing');
    final headers = {
      'Authorization': authorization,
    };

    try {
      final response = await client.get(url, headers: headers);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        final lectureList = body.map((e) => LectureDto.fromJson(e)).toList();
        return Result.success(lectureList);
      }

      return Result.error('Failed to load lecture');
    } catch (e, stackTrace) {
      print(stackTrace);
      return Result.error(e.toString());
    }
  }

  Future<Result<void, String>> startLecture(int id) async {
    final url = Uri.parse('$baseUrl/start/$id');
    final headers = {
      'Authorization': authorization,
    };

    try {
      final response = await client.post(url, headers: headers);

      if (response.statusCode == 200) {
        return Result.success(null);
      }

      print(response.body);
      print(response.statusCode);

      return Result.error('Failed to start lecture');
    } catch (e, stackTrace) {
      print(stackTrace);
      return Result.error(e.toString());
    }
  }

  Future<Result<String, String>> makeLecture(Map<String, dynamic> lecture,
      File? mainImage, List<File> subImages) async {
    final url = Uri.parse(baseUrl);

    print(json.encode(lecture));

    // Create the multipart request
    var request = http.MultipartRequest('POST', url);

    // Add Authorization header
    request.headers['Authorization'] = authorization;
    request.headers['Accept'] = '*/*';
    request.fields['lectureCreateDto'] = json.encode(lecture);

    // Add image files to the request
    if (mainImage != null) {
      var mainImageFile = await http.MultipartFile.fromPath(
          'mainImage', mainImage.path, contentType: MediaType.parse(mimeType(mainImage.path)));
      request.files.add(mainImageFile);
    }
    else {
      Uint8List imageBytes = (await rootBundle.load(
          'assets/images/default/lecture_default.png')).buffer.asUint8List();
      var file = http.MultipartFile.fromBytes(
          'mainImage', imageBytes, filename: 'lecture_default.png', contentType: MediaType('image', 'png'));
      request.files.add(file);
    }


    for (int i = 0; i < subImages.length; i++) {
      var file = await http.MultipartFile.fromPath(
          'image${i + 1}', subImages[i].path, contentType: MediaType.parse(mimeType(subImages[i].path)));
      request.files.add(file);
    }

    print('fields');
    print(request.fields);
    print('fields end');

    // Log all files before sending
    for (var file in request.files) {
      print('File Field: ${file.field}');
      print('File Name: ${file.filename}');
      print('File Content-Type: ${file.contentType}');
      print('File Length: ${file.length}');
    }

    print(request);

    // Send the request
    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      if (response.statusCode == 201) {
        return Result.success(responseBody);
      }
      if (response.statusCode == 200) {
        return Result.success(responseBody);
      }
      if (response.statusCode ~/ 100 == 5) {
        return Result.error('Server error');
      }
      print(responseBody);
      return Result.error('Failed to make lecture');
    } catch (e) {
      return Result.error(e.toString());
    }
  }
}

String mimeType(String filePath) {
  switch (filePath
      .split('.')
      .last
      .toLowerCase()) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'gif':
      return 'image/gif';
    default:
      return 'application/octet-stream'; // Default fallback
  };
}
