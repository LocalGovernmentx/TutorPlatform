import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';

class LoginApiDataSource {
  final http.Client client;

  LoginApiDataSource(this.client);

  static const baseUrl = 'https://www.modututor.com/api';

  Future<Result<Map<String, dynamic>, NetworkErrors>> fetchLogin(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/members/login?email=$email&password=$password'),
      );

      // for testing
      // TODO : Replace this with actual code
      if (email == '1234' && password == '1234') {
        return Result.success({});
      }

      if (email == '1234' && password == '12345') {
        return Result.error(NetworkErrors.credentialsError('Invalid password'));
      }
      return Result.error(NetworkErrors.timeout());

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Result.success(jsonResponse);
      } else {
        // TODO: make more error handling

        return Result.error(NetworkErrors.credentialsError('Invalid email or password'));
      }
    } catch (e) {
      return Result.error(NetworkErrors.timeout());
    }
  }

  Future<Result<dynamic, NetworkErrors>> requestEmailVerify(String email) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/members/emails/verification-requests?email=$email'),
      );


      // TODO: Replace this with actual code
      if (email == '1234') {
        return Result.success(null);
      }
      else if (email == '12345') {
        return Result.error(NetworkErrors.credentialsError('Invalid email format'));
      }
      return Result.error(NetworkErrors.timeout());
    } catch (e) {
      return Result.error(NetworkErrors.timeout());
    }
  }

  Future<Result<String, NetworkErrors>> sendVerificationCode(String email, String code) async {
    try {
      // final response = await client.post(
      //   Uri.parse('$baseUrl/members/emails/verification-requests?email=$email'),
      // );


      // TODO: Replace this with actual code
      if (code == '1234') {
        return Result.success('1234');
      }
      else if (code == '12345') {
        return Result.error(NetworkErrors.credentialsError('Invalid code'));
      }
      return Result.error(NetworkErrors.timeout());
    } catch (e) {
      return Result.error(NetworkErrors.timeout());
    }
  }

  Future<Result<dynamic, NetworkErrors>> changePassword(String email, String password) async {
    try {
      // final response = await client.post(
      //   Uri.parse('$baseUrl/members/emails/verification-requests?email=$email'),
      // );

      // TODO: Replace this with actual code
      return Result.success('1234');
    }
    catch (e) {
      return Result.error(NetworkErrors.timeout());
    }
  }
}
