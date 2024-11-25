import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/models/user_info.dart';
import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/properties/backend_information.dart';
import 'package:tutor_platform/core/result.dart';

class LoginApiDataSource {
  final http.Client client;

  LoginApiDataSource(this.client);

  static const baseUrl = backendBaseUrl;

  Future<Result<JwtToken, NetworkErrors>> login(
      String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/members/login?email=$email&password=$password'),
      );
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 404) {
        try {
          final message = json.decode(response.body)['message'];
          if (message == "Member not found") {
            return Result.error(NetworkErrors.credentialsError(message));
          }
        } catch (e) {
          return Result.error(
              NetworkErrors.clientError(404, 'please update the app'));
        }
      }

      if (response.statusCode == 200) {
        try {
          final accessToken = json.decode(response.body)['accessToken'];
          final refreshToken = json.decode(response.body)['refreshToken'];
          final token =
              JwtToken(accessToken: accessToken, refreshToken: refreshToken);

          return Result.success(token);
        } catch (e) {
          return Result.error(NetworkErrors.unknownStatusCode(
              response.statusCode, response.body));
        }
      }

      final String message;
      try {
        message = json.decode(response.body)['message'];
      } catch (e) {
        return Result.error(NetworkErrors.unknownError());
      }

      switch (response.statusCode) {
        case 401:
          if (message == "Invalid password") {
            return Result.error(NetworkErrors.credentialsError(message));
          }
        default:
          break;
      }

      if (response.statusCode ~/ 100 == 4) {
        return Result.error(
            NetworkErrors.clientError(response.statusCode, message));
      } else if (response.statusCode ~/ 100 == 5) {
        return Result.error(
            NetworkErrors.serverError(response.statusCode, message));
      } else {
        return Result.error(
            NetworkErrors.unknownStatusCode(response.statusCode, message));
      }
    } catch (e, s) {
      print(e);
      print(s);
      return Result.error(NetworkErrors.timeout());
    }
  }

  Future<Result<JwtToken, NetworkErrors>> autoLogin(
      String email, String refreshToken) async {
    try {
      final response = await client.post(
        Uri.parse(
            '$baseUrl/members/refresh?userEmail=$email&refreshToken=$refreshToken'),
      );

      if (response.statusCode == 404) {
        return Result.error(
            NetworkErrors.clientError(404, 'please update the app'));
      }

      if (response.statusCode == 200) {
        try {
          final accessToken = json.decode(response.body)['accessToken'];
          final token =
              JwtToken(accessToken: accessToken, refreshToken: refreshToken);

          return Result.success(token);
        } catch (e) {
          return Result.error(NetworkErrors.unknownStatusCode(
              response.statusCode, response.body));
        }
      }

      final String message;
      try {
        message = json.decode(response.body)['message'];
      } catch (e) {
        return Result.error(NetworkErrors.unknownError());
      }

      switch (response.statusCode) {
        case 401:
          if (message == "Invalid refresh token") {
            return Result.error(NetworkErrors.credentialsError(message));
          }
        default:
          break;
      }

      if (response.statusCode ~/ 100 == 4) {
        return Result.error(
            NetworkErrors.clientError(response.statusCode, message));
      } else if (response.statusCode ~/ 100 == 5) {
        return Result.error(
            NetworkErrors.serverError(response.statusCode, message));
      } else {
        return Result.error(
            NetworkErrors.unknownStatusCode(response.statusCode, message));
      }
    } catch (e) {
      return Result.error(NetworkErrors.timeout());
    }
  }

  Future<Result<String, NetworkErrors>> requestEmailVerification(
      String email) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/members/emails/verification-requests?email=$email'),
      );

      if (response.statusCode == 404) {
        return Result.error(
            NetworkErrors.clientError(404, 'please update the app'));
      }

      try {
        final String message = json.decode(response.body)['message'];
        switch (response.statusCode) {
          case 200:
            if (message == "Verification code sent") {
              return Result.success(message);
            }
          case 400:
            if (message == "Invalid email format") {
              return Result.error(NetworkErrors.credentialsError(message));
            }
        }
      } catch (e) {}

      if (response.statusCode ~/ 100 == 4) {
        return Result.error(NetworkErrors.clientError(response.statusCode, ''));
      } else if (response.statusCode ~/ 100 == 5) {
        return Result.error(NetworkErrors.serverError(response.statusCode, ''));
      } else {
        return Result.error(
            NetworkErrors.unknownStatusCode(response.statusCode, ''));
      }
    } catch (e) {
      return Result.error(NetworkErrors.timeout());
    }
  }

  Future<Result<String, NetworkErrors>> checkEmailDuplicate(
      String email) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/members/check-email?email=$email'),
      );

      print(response.body);

      if (response.statusCode == 404) {
        return Result.error(
            NetworkErrors.clientError(404, 'please update the app'));
      }

      try {
        final String message = json.decode(response.body)['message'];
        switch (response.statusCode) {
          case 200:
            if (message == "Email is available") {
              return Result.success(message);
            }
          case 400:
            if (message == "Invalid email format") {
              return Result.error(NetworkErrors.credentialsError(message));
            }
          case 409:
            if (message == "Email is already in use") {
              return Result.error(NetworkErrors.credentialsError(message));
            }
        }
      } catch (e) {
        // continue to following code
      }

      if (response.statusCode ~/ 100 == 4) {
        return Result.error(NetworkErrors.clientError(response.statusCode, ''));
      } else if (response.statusCode ~/ 100 == 5) {
        return Result.error(NetworkErrors.serverError(response.statusCode, ''));
      } else {
        return Result.error(
            NetworkErrors.unknownStatusCode(response.statusCode, ''));
      }
    } catch (e) {
      return Result.error(NetworkErrors.timeout());
    }
  }

  Future<Result<String, NetworkErrors>> sendVerificationSignUp(
      String email, String code) async {
    try {
      final response = await client.get(
        Uri.parse(
            '$baseUrl/members/emails/verifications-signup?email=$email&code=$code'),
      );

      if (response.statusCode == 404) {
        return Result.error(
            NetworkErrors.clientError(404, 'please update the app'));
      }

      switch (response.statusCode) {
        case 200:
          final String message;
          try {
            message = json.decode(response.body)['message'];
          } catch (e) {
            return Result.error(NetworkErrors.unknownError());
          }
          if (message == "Email verified successfully") {
            return Result.success(message);
          }
        case 400:
          final String message;
          try {
            message = json.decode(response.body)['message'];
          } catch (e) {
            return Result.error(NetworkErrors.unknownError());
          }
          if (message == "Invalid email format") {
            return Result.error(NetworkErrors.credentialsError(message));
          } else if (message == "Invalid verification code") {
            return Result.error(NetworkErrors.credentialsError(message));
          }
        case 409:
          final String message;
          try {
            message = json.decode(response.body)['message'];
          } catch (e) {
            return Result.error(NetworkErrors.unknownError());
          }
          if (message == "Email is already in use") {
            return Result.error(NetworkErrors.credentialsError(message));
          }
        default:
          break;
      }

      if (response.statusCode ~/ 100 == 4) {
        return Result.error(NetworkErrors.clientError(response.statusCode, ''));
      } else if (response.statusCode ~/ 100 == 5) {
        return Result.error(NetworkErrors.serverError(response.statusCode, ''));
      } else {
        return Result.error(
            NetworkErrors.unknownStatusCode(response.statusCode, ''));
      }
    } catch (e) {
      return Result.error(NetworkErrors.timeout());
    }
  }

  Future<Result<String, NetworkErrors>> checkNickname(String nickname) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/members/check-nickname?nickname=$nickname'),
      );

      if (response.statusCode == 404) {
        return Result.error(
            NetworkErrors.clientError(404, 'please update the app'));
      }

      switch (response.statusCode) {
        case 200:
          final String message;
          try {
            message = json.decode(response.body)['message'];
          } catch (e) {
            return Result.error(NetworkErrors.unknownError());
          }
          if (message == "Nickname is available") {
            return Result.success(message);
          }
        case 409:
          final String message;
          try {
            message = json.decode(response.body)['message'];
          } catch (e) {
            return Result.error(NetworkErrors.unknownError());
          }
          if (message == "Nickname is already in use") {
            return Result.error(NetworkErrors.credentialsError(message));
          }
        default:
          break;
      }

      if (response.statusCode ~/ 100 == 4) {
        return Result.error(NetworkErrors.clientError(response.statusCode, ''));
      } else if (response.statusCode ~/ 100 == 5) {
        return Result.error(NetworkErrors.serverError(response.statusCode, ''));
      } else {
        return Result.error(
            NetworkErrors.unknownStatusCode(response.statusCode, ''));
      }
    } catch (e) {
      return Result.error(NetworkErrors.timeout());
    }
  }

  Future<Result<String, NetworkErrors>> register(UserInfo userInfo) async {
    print(userInfo.toJson());
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/members'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(userInfo.toJson()),
      );

      if (response.statusCode == 404) {
        return Result.error(
            NetworkErrors.clientError(404, 'please update the app'));
      }

      try {
        final String message = json.decode(response.body)['message'];
        switch (response.statusCode) {
          case 200:
            if (message == "Member created successfully") {
              return Result.success(message);
            }
          case 400:
            if (message == "Nickname must be between 2 and 8 characters long") {
              return Result.error(NetworkErrors.credentialsError(message));
            }
          case 403:
            if (message == "Email is not verified") {
              return Result.error(NetworkErrors.credentialsError(message));
            }
          case 406:
            if (message == "Phone number is already in use") {
              return Result.error(NetworkErrors.credentialsError(message));
            }
          case 409:
            if (message == "Email is already in use") {
              return Result.error(NetworkErrors.credentialsError(message));
            }
          case 411:
            if (message == "Password is too short") {
              return Result.error(NetworkErrors.credentialsError(message));
            }
          case 422:
            if (message == "Invalid email format") {
              return Result.error(NetworkErrors.credentialsError(message));
            }
          default:
            break;
        }
      } catch (e) {
        // continue to following code
      }

      if (response.statusCode ~/ 100 == 4) {
        return Result.error(NetworkErrors.clientError(response.statusCode, ''));
      } else if (response.statusCode ~/ 100 == 5) {
        return Result.error(NetworkErrors.serverError(response.statusCode, ''));
      } else {
        return Result.error(
            NetworkErrors.unknownStatusCode(response.statusCode, ''));
      }
    } catch (e) {
      return Result.error(NetworkErrors.timeout());
    }
  }

  Future<Result<String, NetworkErrors>> sendVerificationFindPassword(
      String email, String code) async {
    try {
      final response = await client.get(
        Uri.parse(
            '$baseUrl/members/emails/verifications?email=$email&code=$code'),
      );

      if (response.statusCode == 404) {
        try {
          final message = json.decode(response.body)['message'];
          if (message == "Email not found") {
            return Result.error(NetworkErrors.credentialsError(message));
          }
        } catch (e) {
          // continue to following code
        }
        return Result.error(
            NetworkErrors.clientError(404, 'please update the app'));
      }

      try {
        final String message = json.decode(response.body)['message'];
        switch (response.statusCode) {
          case 200:
            if (message == "Email verified successfully") {
              return Result.success(message);
            }
          case 400:
            if (message == "Invalid verification code") {
              return Result.error(NetworkErrors.credentialsError(message));
            }
            if (message == "Invalid email format") {
              return Result.error(NetworkErrors.credentialsError(message));
            }
          default:
            break;
        }
      } catch (e) {
        // continue to following code
      }

      if (response.statusCode ~/ 100 == 4) {
        return Result.error(NetworkErrors.clientError(response.statusCode, ''));
      } else if (response.statusCode ~/ 100 == 5) {
        return Result.error(NetworkErrors.serverError(response.statusCode, ''));
      } else {
        return Result.error(
            NetworkErrors.unknownStatusCode(response.statusCode, ''));
      }
    } catch (e) {
      return Result.error(NetworkErrors.timeout());
    }
  }

  Future<Result<String, NetworkErrors>> changePassword(
      String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse(
            '$baseUrl/members/emails/password-email?email=$email&password=$password'),
      );

      if (response.statusCode == 404) {
        try {
          final message = json.decode(response.body)['message'];
          if (message == "Email not found") {
            return Result.error(NetworkErrors.credentialsError(message));
          }
        } catch (e) {
          // continue to following code
        }
        return Result.error(
            NetworkErrors.clientError(404, 'please update the app'));
      }

      try {
        final String message = json.decode(response.body)['message'];
        switch (response.statusCode) {
          case 200:
            if (message == "Password changed successfully") {
              return Result.success(message);
            }
          case 400:
            if (message == "Password change failed") {
              return Result.error(NetworkErrors.credentialsError(message));
            }
            if (message == "Invalid email format") {
              return Result.error(NetworkErrors.credentialsError(message));
            }
          default:
            break;
        }
      } catch (e) {
        // continue to following code
      }

      if (response.statusCode ~/ 100 == 4) {
        return Result.error(NetworkErrors.clientError(response.statusCode, ''));
      } else if (response.statusCode ~/ 100 == 5) {
        return Result.error(NetworkErrors.serverError(response.statusCode, ''));
      } else {
        return Result.error(
            NetworkErrors.unknownStatusCode(response.statusCode, ''));
      }
    } catch (e) {
      return Result.error(NetworkErrors.timeout());
    }
  }

  Future<Result<UserInfo, NetworkErrors>> getMyInfo(String authorization) async {
    try {
      final url = Uri.parse('$baseUrl/members/me');
      final response = await client.get(url, headers: {
        'Authorization': authorization,
      });

      if (response.statusCode == 404) {
        print(1);
        return Result.error(
            NetworkErrors.clientError(404, 'please update the app'));
      }
      else if(response.statusCode == 200) {
        final userInfo = UserInfo.fromJson(json.decode(response.body));

        final Result<UserInfo, NetworkErrors> result = Result.success(userInfo);
        return result;
      }

      if (response.statusCode ~/ 100 == 4) {
        return Result.error(NetworkErrors.clientError(response.statusCode, ''));
      } else if (response.statusCode ~/ 100 == 5) {
        return Result.error(NetworkErrors.serverError(response.statusCode, ''));
      } else {
        return Result.error(
            NetworkErrors.unknownStatusCode(response.statusCode, ''));
      }
    }
    catch (e) {
      print(e);
      return Result.error(NetworkErrors.timeout());
    }
  }

}
