import 'package:freezed_annotation/freezed_annotation.dart';

part 'jwt_token.freezed.dart';

part 'jwt_token.g.dart';

@freezed
class JwtToken with _$JwtToken {
  const factory JwtToken({
    required String accessToken,
    required String refreshToken,
  }) = _UserInfo;

  factory JwtToken.fromJson(Map<String, dynamic> json) =>
      _$JwtTokenFromJson(json);
}
