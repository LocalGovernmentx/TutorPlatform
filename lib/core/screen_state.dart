import 'package:tutor_platform/core/user_info.dart';

sealed class ScreenState {
  const factory ScreenState.signInUpScreen() = SignInUpScreen;

  const factory ScreenState.tuteeScreen(UserInfo userInfo) = TuteeScreen;

  const factory ScreenState.tutorScreen(UserInfo userInfo) = TutorScreen;
}

class SignInUpScreen implements ScreenState {
  const SignInUpScreen();
}

class TuteeScreen implements ScreenState {
  final UserInfo userInfo;

  const TuteeScreen(this.userInfo);
}

class TutorScreen implements ScreenState {
  final UserInfo userInfo;

  const TutorScreen(this.userInfo);
}
