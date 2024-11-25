import 'package:freezed_annotation/freezed_annotation.dart';

part 'after_school_dto.freezed.dart';
part 'after_school_dto.g.dart';

@freezed
class AfterSchoolDto with _$AfterSchoolDto {
  factory AfterSchoolDto({
    required int id,
    required String title,
    required String content,
    required String region,
    required String keyValue,
    required String? fileName,
    required String fileContent,
    required String filePath,
  }) = _AfterSchoolDto;

  factory AfterSchoolDto.fromJson(Map<String, dynamic> json) => _$AfterSchoolDtoFromJson(json);
}
