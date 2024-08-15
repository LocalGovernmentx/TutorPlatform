import 'package:tutor_platform/core/models/jwt_token.dart';

sealed class ScreenState {
  const factory ScreenState.signInUpScreenState(bool autoLogin) = SignInUpScreenState;

  const factory ScreenState.tuteeScreenState(JwtToken jwtToken) = TuteeScreenState;

  const factory ScreenState.tutorScreenState(JwtToken jwtToken) = TutorScreenState;
}

class SignInUpScreenState implements ScreenState {
  final bool autoLogin;

  const SignInUpScreenState(this.autoLogin);
}

class TuteeScreenState implements ScreenState {
  final JwtToken jwtToken;

  const TuteeScreenState(this.jwtToken);
}

class TutorScreenState implements ScreenState {
  final JwtToken jwtToken;

  const TutorScreenState(this.jwtToken);
}
