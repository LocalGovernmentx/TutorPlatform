import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/models/user_info.dart';

sealed class ScreenState {
  const factory ScreenState.signInUpScreenState(bool autoLogin) = SignInUpScreenState;

  const factory ScreenState.tuteeScreenState(JwtToken jwtToken, UserInfo userInfo) = TuteeScreenState;

  const factory ScreenState.tutorScreenState(JwtToken jwtToken, UserInfo userInfo) = TutorScreenState;
}

class SignInUpScreenState implements ScreenState {
  final bool autoLogin;

  const SignInUpScreenState(this.autoLogin);
}

class TuteeScreenState implements ScreenState {
  final JwtToken jwtToken;
  final UserInfo userInfo;

  const TuteeScreenState(this.jwtToken, this.userInfo);
}

class TutorScreenState implements ScreenState {
  final JwtToken jwtToken;
  final UserInfo userInfo;

  const TutorScreenState(this.jwtToken, this.userInfo);
}
