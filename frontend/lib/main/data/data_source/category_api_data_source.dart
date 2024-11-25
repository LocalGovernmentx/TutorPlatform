import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/properties/backend_information.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/domain/model/dto/category_data.dart';

class CategoryApiDataSource {
  final http.Client client;
  final JwtToken jwtToken;
  final String authorization;

  CategoryApiDataSource(this.client, this.jwtToken)
      : authorization = jwtToken.accessToken;

  static const baseUrl = '$backendBaseUrl/category';

  Future<Result<List<CategoryData>,String>> getCategories() async {
    final url = Uri.parse(baseUrl);
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
      final List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      final cleanList = [for (var category in body) CategoryData.fromJson(category)];
      return Result.success(cleanList);
    }

    return Result.error('Failed to load categories');
  }

  Future<Result<CategoryData, String>> getCategory(int id) async {
    final url = Uri.parse('$baseUrl/$id');
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
      return Result.success(CategoryData.fromJson(body));
    }

    print(response.statusCode);
    print(response.body);

    return Result.error('Failed to update categories');
  }
}