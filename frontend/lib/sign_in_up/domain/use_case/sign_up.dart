import 'package:intl/intl.dart';
import 'package:tutor_platform/core/models/user_info.dart';
import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/properties/member_property.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';

class SignUp {
  final LoginApiRepository _loginApiRepository;

  SignUp(this._loginApiRepository);

  Future<Result<String, NetworkErrors>> call(
      String name,
      String password,
      String email,
      String nickname,
      String phoneNumber,
      int gender,
      DateTime birth,
      String inviteCode,
      bool isTutor) {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    final userInfo = UserInfo(
      name: name,
      password: password,
      email: email,
      nickname: nickname,
      phoneNumber: phoneNumber,
      gender: gender,
      birth: formatter.format(birth),
      type: isTutor ? MemberProperty.tutorType : MemberProperty.tuteeType,
      lastlogin: DateTime.now().toUtc().toIso8601String(),
    );
    return _loginApiRepository.register(userInfo);
  }
}
