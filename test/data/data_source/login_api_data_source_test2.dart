import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tutor_platform/core/models/user_info.dart';
import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/data/data_source/login_api_data_source.dart';

void main() async {
  final client = http.Client();
  final loginApi = LoginApiDataSource(client);

  DateTime now = DateTime.now().toUtc();
  String isoString = now.toIso8601String();
  print(isoString);

  DateFormat formatter = DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(now);

  final jsonDecoded = jsonDecode(fakeJson);

  jsonDecoded['lastlogin'] = isoString;
  jsonDecoded['birth'] = formattedDate;

  final userInfo = UserInfo.fromJson(jsonDecoded);

  print(userInfo);

  final Result<String, NetworkErrors> response = await loginApi.register(userInfo);

  if (response case Error<String, NetworkErrors>()) {
    print(response.error);
    final error = response.error;
    if (error case CredentialsError()) {
      print(error.message);
    }
  } else {
    print(response);
  }

}


String fakeJson = '''
{
  "name": "Jiberish Johnson",
  "password": "someValidPassword123",
  "email": "email.nobody.uses@nowhere.com",
  "nickname": "Johnson",
  "phoneNumber": "012-345-6789",
  "gender": 1,
  "birth": "1990-01-01",
  "verifiedOauth": false,
  "lastlogin": "2024-08-13T12:00:00Z",
  "type": 1,
  "inviteCode": "",
  "image": ""
}
''';