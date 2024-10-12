import 'package:flutter/cupertino.dart';
import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/models/user_info.dart';
import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/get_my_info.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/perform_autologin.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/remove_remember_me.dart';

class AutoLoginViewModel extends ChangeNotifier {
  final PerformAutologin _performAutologin;
  final RemoveRememberMe _removeRememberMe;
  final GetMyInfo _getMyInfo;

  AutoLoginViewModel(
    this._performAutologin,
    this._removeRememberMe,
    this._getMyInfo,
  );

  void removeRememberMe() {
    _removeRememberMe();
  }

  Future<Result<JwtToken, String>> autoLogin() async {
    return await _performAutologin();
  }

  Future<Result<UserInfo, NetworkErrors>> getMyInfo(String authorization) async {
    return await _getMyInfo(authorization);
  }
}
