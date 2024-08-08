sealed class LoginEvent {
  factory LoginEvent.login(String email, String password) = Login;

  factory LoginEvent.autoLogin() = AutoLogin;
}

class Login implements LoginEvent {
  final String email;
  final String password;

  Login(this.email, this.password);
}

class AutoLogin implements LoginEvent {}