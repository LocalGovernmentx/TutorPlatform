import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/model/login_credentials.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/remember_me_repository.dart';

class PerformAutologin {
  final LoginApiRepository _loginApiRepository;
  final RememberMeRepository _rememberMeRepository;

  PerformAutologin(this._loginApiRepository, this._rememberMeRepository);

  Future<Result<JwtToken, String>> call() async {
    LoginCredentials? loginCredentials = await _rememberMeRepository.getRememberMe();
    if (loginCredentials == null) {
      return Result.error("");
    }

    final String email = loginCredentials.email;
    final String refreshToken = loginCredentials.refreshToken;
    if (email.isEmpty || refreshToken.isEmpty) {
      return Result.error("");
    }

    Result<JwtToken, dynamic> result = await _loginApiRepository.autoLogin(email, refreshToken);
    if (result case Success<JwtToken, dynamic>()) {
      return Result.success(result.value);
    } else {
      _rememberMeRepository.removeRememberMe();
      return Result.error("자동로그인이 실패하였습니다.");
    }
  }
}