import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info.freezed.dart';
part 'user_info.g.dart';

@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
    @Default(0) int id,
    required String? name,
    required String? password,
    required String? email,
    required String? nickname,
    required String? phoneNumber,
    required int? gender,
    required String? birth,
    @Default(false) bool? verifiedOauth,
    required String? lastlogin,
    required int? type,
    @Default('') String? inviteCode,
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
}
