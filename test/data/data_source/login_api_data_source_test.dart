import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/sign_in_up/data/data_source/login_api_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_platform/core/result.dart';

import 'login_api_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  test('LoginApiDataSource.requestEmailVerify testing', () async {
    final client = MockClient();
    final loginApi = LoginApiDataSource(client);

    const validEmail = 'sth@example.com';
    const invalidEmail = '1234';

    when(client.post(Uri.parse(
            '${LoginApiDataSource.baseUrl}/members/emails/verification-requests?email=$validEmail')))
        .thenAnswer(
      (_) async => http.Response(fakeVerificationCodeSentJsonBody, 200),
    );

    when(client.post(Uri.parse(
            '${LoginApiDataSource.baseUrl}/members/emails/verification-requests?email=$invalidEmail')))
        .thenAnswer(
      (_) async => http.Response(fakeInvalidEmailJsonBody, 400),
    );

    loginApi.requestEmailVerification(validEmail).then((value) {
      if (value case Success<String, NetworkErrors>()) {
        expect(value.value, 'Verification code sent');
      } else {
        fail('Expected Success but got $value');
      }
    });

    loginApi.requestEmailVerification(invalidEmail).then((value) {
      if (value case Error<String, NetworkErrors>()) {
        NetworkErrors error = value.error;
        if (error case CredentialsError()) {
          expect(error.message, 'Invalid email format');
        } else {
          fail('Expected CredentialsError but got $error');
        }
      } else {
        fail('Expected Error but got $value');
      }
    });

    client.close();
  });

  test('LoginApiDataSource.sendVerificationSignUp testing', () async {
    final client = MockClient();
    final loginApi = LoginApiDataSource(client);

    const validEmail = 'sth@example.com';
    const invalidEmail = '1234';
    const usedEmail = 'sth2@example.com';

    const validCode = '1234';
    const invalidCode = '0000';

    when(client.get(Uri.parse(
            '${LoginApiDataSource.baseUrl}/members/emails/verifications-signup?email=$validEmail&code=$validCode')))
        .thenAnswer(
      (_) async => http.Response(fakeEmailVerifiedSuccessfullyJsonBody, 200),
    );
    when(client.get(Uri.parse(
            '${LoginApiDataSource.baseUrl}/members/emails/verifications-signup?email=$invalidEmail&code=$validCode')))
        .thenAnswer(
      (_) async => http.Response(fakeInvalidEmailJsonBody, 400),
    );
    when(client.get(Uri.parse(
            '${LoginApiDataSource.baseUrl}/members/emails/verifications-signup?email=$validEmail&code=$invalidCode')))
        .thenAnswer(
      (_) async => http.Response(fakeInvalidVerificationCodeJsonBody, 400),
    );
    when(client.get(Uri.parse(
            '${LoginApiDataSource.baseUrl}/members/emails/verifications-signup?email=$usedEmail&code=$validCode')))
        .thenAnswer(
      (_) async => http.Response(fakeEmailAlreadyInUseJsonBody, 409),
    );

    loginApi.sendVerificationSignUp(validEmail, validCode).then((value) {
      if (value case Success<String, NetworkErrors>()) {
        expect(value.value, 'Email verified successfully');
      } else {
        fail(
            'Expected Success but got $value, ${((value as Error).error as UnknownStatusCode).statusCode}');
      }
    });

    loginApi.sendVerificationSignUp(invalidEmail, validCode).then((value) {
      if (value case Error<String, NetworkErrors>()) {
        NetworkErrors error = value.error;
        if (error case CredentialsError()) {
          expect(error.message, 'Invalid email format');
        } else {
          fail('Expected CredentialsError but got $error');
        }
      } else {
        fail('Expected Error but got $value');
      }
    });

    loginApi.sendVerificationSignUp(usedEmail, validCode).then((value) {
      if (value case Error<String, NetworkErrors>()) {
        NetworkErrors error = value.error;
        if (error case CredentialsError()) {
          expect(error.message, 'Email is already in use');
        } else {
          fail('Expected CredentialsError but got $error');
        }
      } else {
        fail('Expected Error but got $value');
      }
    });

    loginApi.sendVerificationSignUp(validEmail, invalidCode).then((value) {
      if (value case Error<String, NetworkErrors>()) {
        NetworkErrors error = value.error;
        if (error case CredentialsError()) {
          expect(error.message, 'Invalid verification code');
        } else {
          fail('Expected CredentialsError but got $error');
        }
      } else {
        fail('Expected Error but got $value');
      }
    });

    client.close();
  });

  test('LoginApiDataSource.login testing', () async {
    final client = MockClient();
    final loginApi = LoginApiDataSource(client);

    const validEmail = 'sth@example.com';
    const validPassword = '1234';
    const invalidEmail = '1234';
    const invalidPassword = '0000';

    when(client.post(
      Uri.parse(
          '${LoginApiDataSource.baseUrl}/members/login?email=$validEmail&password=$validPassword'),
    )).thenAnswer(
      (_) async => http.Response(fakeLoginSuccessJsonBody, 200),
    );
    when(client.post(
      Uri.parse(
          '${LoginApiDataSource.baseUrl}/members/login?email=$invalidEmail&password=$validPassword'),
    )).thenAnswer(
      (_) async => http.Response(fakeLoginInvalidEmailJsonBody, 404),
    );
    when(client.post(
      Uri.parse(
          '${LoginApiDataSource.baseUrl}/members/login?email=$validEmail&password=$invalidPassword'),
    )).thenAnswer(
      (_) async => http.Response(fakeLoginInvalidPasswordJsonBody, 401),
    );

    loginApi.login(validEmail, validPassword).then((value) {
      if (value case Success<JwtToken, NetworkErrors>()) {
        JwtToken token = value.value;
        String accessToken =
            jsonDecode(fakeLoginSuccessJsonBody)['accessToken'];
        String refreshToken =
            jsonDecode(fakeLoginSuccessJsonBody)['refreshToken'];

        expect(token.accessToken, accessToken);
        expect(token.refreshToken, refreshToken);
      } else {
        fail('Expected Success but got $value');
      }
    });

    loginApi.login(invalidEmail, validPassword).then((value) {
      if (value case Error<JwtToken, NetworkErrors>()) {
        NetworkErrors error = value.error;
        if (error case CredentialsError()) {
          expect(error.message, 'Member not found');
        } else {
          fail('Expected CredentialsError but got $error');
        }
      } else {
        fail('Expected Error but got $value');
      }
    });

    loginApi.login(validEmail, invalidPassword).then((value) {
      if (value case Error<JwtToken, NetworkErrors>()) {
        NetworkErrors error = value.error;
        if (error case CredentialsError()) {
          expect(error.message, 'Invalid password');
        } else {
          fail('Expected ClientError but got $error');
        }
      } else {
        fail('Expected Error but got $value');
      }
    });

    client.close();
  });

  test('LoginApiDataSource.checkNickname testing', () async {
    final client = MockClient();
    final loginApi = LoginApiDataSource(client);

    const validNickname = 'nickname';
    const invalidNickname = 'nickname2';

    when(client.get(
      Uri.parse(
          '${LoginApiDataSource.baseUrl}/members/check-nickname?nickname=$validNickname'),
    )).thenAnswer(
      (_) async => http.Response(fakeAvailableNicknameJsonBody, 200),
    );
    when(client.get(
      Uri.parse(
          '${LoginApiDataSource.baseUrl}/members/check-nickname?nickname=$invalidNickname'),
    )).thenAnswer(
      (_) async => http.Response(fakeNicknameAlreadyInUseJsonBody, 409),
    );

    loginApi.checkNickname(validNickname).then((value) {
      if (value case Success<String, NetworkErrors>()) {
        expect(value.value, 'Nickname is available');
      } else {
        fail('Expected Success but got $value');
      }
    });

    loginApi.checkNickname(invalidNickname).then((value) {
      if (value case Error<String, NetworkErrors>()) {
        NetworkErrors error = value.error;
        if (error case CredentialsError()) {
          expect(error.message, 'Nickname is already in use');
        } else {
          fail('Expected CredentialsError but got $error');
        }
      } else {
        fail('Expected Error but got $value');
      }
    });
  });

  test('LoginApiDataSource.autoLogin testing', () async {
    final client = MockClient();
    final loginApi = LoginApiDataSource(client);

    const validEmail = 'sth@example.com';
    const validRefreshToken = 'valid-refresh-token';
    const invalidEmail = '1234';
    const invalidRefreshToken = 'invalid-refresh-token';

    when(client.post(
      Uri.parse(
          '${LoginApiDataSource.baseUrl}/members/refresh?userEmail=$validEmail&refreshToken=$validRefreshToken'),
    )).thenAnswer(
      (_) async => http.Response(fakeAutologinSuccessJsonBody, 200),
    );
    when(client.post(
      Uri.parse(
          '${LoginApiDataSource.baseUrl}/members/refresh?userEmail=$invalidEmail&refreshToken=$validRefreshToken'),
    )).thenAnswer(
      (_) async => http.Response(fakeAutologinInvalidTokenJsonBody, 401),
    );
    when(client.post(
      Uri.parse(
          '${LoginApiDataSource.baseUrl}/members/refresh?userEmail=$validEmail&refreshToken=$invalidRefreshToken'),
    )).thenAnswer(
      (_) async => http.Response(fakeAutologinInvalidTokenJsonBody, 401),
    );

    loginApi.autoLogin(validEmail, validRefreshToken).then((value) {
      if (value case Success<JwtToken, NetworkErrors>()) {
        JwtToken token = value.value;
        String accessToken =
            jsonDecode(fakeAutologinSuccessJsonBody)['accessToken'];

        expect(token.accessToken, accessToken);
      } else {
        fail('Expected Success but got $value');
      }
    });

    loginApi.autoLogin(invalidEmail, validRefreshToken).then((value) {
      if (value case Error<JwtToken, NetworkErrors>()) {
        NetworkErrors error = value.error;
        if (error case CredentialsError()) {
          expect(error.message, 'Invalid refresh token');
        } else {
          fail('Expected CredentialsError but got $error');
        }
      } else {
        fail('Expected Error but got $value');
      }
    });

    loginApi.autoLogin(validEmail, invalidRefreshToken).then((value) {
      if (value case Error<JwtToken, NetworkErrors>()) {
        NetworkErrors error = value.error;
        if (error case CredentialsError()) {
          expect(error.message, 'Invalid refresh token');
        } else {
          fail('Expected CredentialsError but got $error');
        }
      } else {
        fail('Expected Error but got $value');
      }
    });
  });
}

String fakeAutologinSuccessJsonBody = '''
{
  "accessToken": "Bearer token-info"
}
''';

String fakeAutologinInvalidTokenJsonBody = '''
{
  "message" : "Invalid refresh token"
}
''';

String fakeAvailableNicknameJsonBody = '''
{
  "message" : "Nickname is available"
}
''';

String fakeNicknameAlreadyInUseJsonBody = '''
{
  "message" : "Nickname is already in use"
}
''';

String fakeLoginSuccessJsonBody = '''
{
  "accessToken": "Bearer token-info",
  "refreshToken": "refresh-token"
}
''';

String fakeLoginInvalidEmailJsonBody = '''
{
  "message" : "Member not found"
}
''';

String fakeLoginInvalidPasswordJsonBody = '''
{
  "message" : "Invalid password"
}
''';

String fakeInvalidEmailJsonBody = '''
{
  "message" : "Invalid email format"
}
''';

String fakeVerificationCodeSentJsonBody = '''
{
  "message" : "Verification code sent"
}
''';

String fakeEmailVerifiedSuccessfullyJsonBody = '''
{
  "message" : "Email verified successfully"
}
''';

String fakeInvalidVerificationCodeJsonBody = '''
{
  "message" : "Invalid verification code"
}
''';

String fakeEmailAlreadyInUseJsonBody = '''
{
  "message" : "Email is already in use"
}
''';
