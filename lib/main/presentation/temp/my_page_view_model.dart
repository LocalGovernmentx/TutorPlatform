import 'package:flutter/cupertino.dart';
import 'package:tutor_platform/main/domain/use_case/handling_user_info.dart';

class MyPageViewModel extends ChangeNotifier {
  final HandlingUserInfo _handlingUserInfo;

  get jwtToken => _handlingUserInfo.jwtToken;
  get userInfo => _handlingUserInfo.userInfo;
  get isTutor => _handlingUserInfo.isTutor;

  MyPageViewModel(this._handlingUserInfo);
}