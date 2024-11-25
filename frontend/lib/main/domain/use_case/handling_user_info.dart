import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/models/user_info.dart';

class HandlingUserInfo {
  final JwtToken jwtToken;
  final UserInfo userInfo;
  final bool isTutor;

  HandlingUserInfo(this.jwtToken, this.userInfo, this.isTutor);
}