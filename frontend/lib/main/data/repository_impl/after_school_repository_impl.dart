import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/data/data_source/after_school_api.dart';
import 'package:tutor_platform/main/domain/model/dto/after_school_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/page_simple_after_school_notice_response_dto.dart';
import 'package:tutor_platform/main/domain/repository/after_school_repository.dart';

class AfterSchoolRepositoryImpl implements AfterSchoolRepository {
  final AfterSchoolApiDataSource dataSource;

  const AfterSchoolRepositoryImpl(this.dataSource);

  @override
  Future<Result<AfterSchoolDto, String>> getAfterSchoolNotice(int id) {
    return dataSource.getAfterSchoolNotice(id);
  }

  @override
  Future<Result<PageSimpleAfterSchoolNoticeResponseDto, String>> getAfterSchoolNotices(int page, int size) {
    return dataSource.getAfterSchoolNotices(page, size);
  }

}