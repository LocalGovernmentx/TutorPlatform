import 'package:tutor_platform/core/user_info.dart';

sealed class ScreenState {
  const factory ScreenState.signInUpScreenState(bool autoLogin) = SignInUpScreenState;

  const factory ScreenState.tuteeScreenState(UserInfo userInfo) = TuteeScreenState;

  const factory ScreenState.tutorScreenState(UserInfo userInfo) = TutorScreenState;
}

class SignInUpScreenState implements ScreenState {
  final bool autoLogin;

  const SignInUpScreenState(this.autoLogin);
}

class TuteeScreenState implements ScreenState {
  final UserInfo userInfo;

  const TuteeScreenState(this.userInfo);
}

class TutorScreenState implements ScreenState {
  final UserInfo userInfo;

  const TutorScreenState(this.userInfo);
}
