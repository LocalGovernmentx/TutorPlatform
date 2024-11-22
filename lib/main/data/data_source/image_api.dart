import 'dart:typed_data';

import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/properties/backend_information.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:http/http.dart' as http;

class ImageApi {
  final http.Client client;
  final JwtToken jwtToken;
  final String authorization;

  ImageApi(this.client, this.jwtToken)
      : authorization = jwtToken.accessToken;

  static const baseUrl = '$backendBaseUrl/images/member';

  Future<Result<String, String>> postImage(Uint8List imageData) async {
    final url = Uri.parse(baseUrl);
    final headers = {
      'Authorization': authorization,
      'Content-Type': 'multipart/form-data',
    };

    late http.Response response;
    try {
      response = await client.post(url, headers: headers, body: imageData);
    } catch (e) {
      return Result.error(e.toString());
    }

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      return Result.success(response.body);
    }

    return Result.error('Failed to post image');
  }
}