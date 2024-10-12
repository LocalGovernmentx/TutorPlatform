import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/properties/backend_information.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/domain/model/dto/lecture_small_view.dart';

class DibsApiDataSource {
  final http.Client client;
  final JwtToken jwtToken;

  static const baseUrl = '$backendBaseUrl/dibs';

  DibsApiDataSource(this.client, this.jwtToken);

  Future<Result<List<LectureSmallView>, String>> getDibs() async {
    final url = Uri.parse(baseUrl);
    final headers = {
      'Authorization': jwtToken.accessToken,
    };

    late http.Response response;
    try {
      response = await client.get(url, headers: headers);
    } catch (e) {
      return Result.error(e.toString());
    }

    if (response.statusCode == 200) {
      final List<dynamic> lectureList = jsonDecode(response.body);
      print(lectureList);
      return Result.success(
        lectureList.map((e) => LectureSmallView.fromJson(e)).toList(),
      );
    }

    return Result.error(response.body);
  }

  Future<Result<void, String>> addDib(int id) async {
    final url = Uri.parse('$baseUrl/$id');
    final headers = {
      'Authorization': jwtToken.accessToken,
    };
    final body = jsonEncode({'id': id});

    late http.Response response;
    try {
      response = await client.post(url, headers: headers, body: body);
    } catch (e) {
      return Result.error(e.toString());
    }

    if (response.statusCode == 200) {
      return Result.success(null);
    }

    return Result.error(response.body);
  }

  Future<Result<void, String>> removeDib(int id) async {
    final url = Uri.parse('$baseUrl/$id');
    final headers = {
      'Authorization': jwtToken.accessToken,
    };

    late http.Response response;
    try {
      response = await client.delete(url, headers: headers);
    } catch (e) {
      return Result.error(e.toString());
    }

    if (response.statusCode == 200) {
      return Result.success(null);
    }

    return Result.error(response.body);
  }
}
