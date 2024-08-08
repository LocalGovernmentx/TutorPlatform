import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tutor_platform/sign_in_up/data/data_source/result.dart';

class LoginApiDataSource {
  final http.Client client;

  LoginApiDataSource(this.client);

  static const baseUrl = 'https://www.modututor.com/api/members/login';

  Future<Result<Map<String, dynamic>>> fetch(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl?email=$email&password=$password'),
      );

      // for testing
      // ToDo : Replace this with actual code
      if (email == '1234' && password == '1234') {
        return Result.success({});
      }

      if (email == '1234' && password == '12345') {
        return Result.error('Invalid email or password');
      }
      return Result.error('Networking error');




      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Result.success(jsonResponse);
      } else {
        // TODO: make more error handling







        return Result.error('Failed to load data');
      }
    } catch (e) {
      return Result.error('Networking error');
    }
  }
}
