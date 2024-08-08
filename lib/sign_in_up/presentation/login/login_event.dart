sealed class LoginEvent {
  factory LoginEvent.login(String email, String password) = Login;

  factory LoginEvent.autoLogin() = AutoLogin;

  factory LoginEvent.stopRememberMe() = StopRememberMe;
}

class Login implements LoginEvent {
  final String email;
  final String password;

  Login(this.email, this.password);
}

class AutoLogin implements LoginEvent {}

class StopRememberMe implements LoginEvent {}