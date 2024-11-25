import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/domain/model/dto/after_school_dto.dart';
import 'package:tutor_platform/main/domain/repository/after_school_repository.dart';

class ObtainAfterSchool {
  final AfterSchoolRepository _afterSchoolRepository;

  ObtainAfterSchool(this._afterSchoolRepository);

  Future<AfterSchoolDto> call(int id) async {
    final Result<AfterSchoolDto, String> result
      = await _afterSchoolRepository.getAfterSchoolNotice(id);
    if (result is Error<AfterSchoolDto, String>) {
      throw Exception(result.error);
    } else if (result is Success<AfterSchoolDto, String>) {
      return result.value;
    } else {
      throw Exception('Unknown error');
    }
  }
}