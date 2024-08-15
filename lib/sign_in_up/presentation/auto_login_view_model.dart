import 'package:flutter/cupertino.dart';
import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/perform_autologin.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/remove_remember_me.dart';

class AutoLoginViewModel extends ChangeNotifier {
  final PerformAutologin _performAutologin;
  final RemoveRememberMe _removeRememberMe;

  AutoLoginViewModel(
    this._performAutologin,
    this._removeRememberMe,
  );

  void removeRememberMe() {
    _removeRememberMe();
  }

  Future<Result<JwtToken, String>> autoLogin() async {
    return await _performAutologin();
  }
}
