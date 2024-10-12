import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/properties/backend_information.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/page_lecture_dto.dart';

class LectureApiDataSource {
  final http.Client client;
  final JwtToken jwtToken;
  final String authorization;

  LectureApiDataSource(this.client, this.jwtToken)
      : authorization = jwtToken.accessToken;

  static const baseUrl = '$backendBaseUrl/lectures';

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
      final Map<String, dynamic> body = json.decode(response.body);
      return Result.success(PageLectureDto.fromJson(body));
    }

    return Result.error('Failed to load lectures');
  }

  Future<Result<PageLectureDto, String>> getLectureWithFiltering(
      int page, int size, List<int> categoryId, int onOffline, int? maxPrice) async {
    String urlStr = '$baseUrl/list?page=$page&size=$size&online=$onOffline';

    if (maxPrice != null) {
      urlStr += '&maxPrice=$maxPrice';
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
      final Map<String, dynamic> body = json.decode(response.body);
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
        final body = json.decode(response.body);
        return Result.success(LectureDto.fromJson(body));
      }
      return Result.error('Failed to load lecture');
    } catch (e, stackTrace) {
      print(stackTrace);
      return Result.error(e.toString());
    }
  }

  Future<Result<List<LectureDto>, String>> getOngoingLectures(
      int id, int size) async {
    final url = Uri.parse('$baseUrl/ongoing');
    final headers = {
      'Authorization': authorization,
    };

    try {
      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        final lectureList = body.map((e) => LectureDto.fromJson(e)).toList();
        return Result.success(lectureList);
      }

      print(response.body);
      print(response.statusCode);

      return Result.error('Failed to load lecture');
    } catch (e, stackTrace) {
      print(stackTrace);
      return Result.error(e.toString());
    }
  }
}
