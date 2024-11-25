import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/domain/model/dto/after_school_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/page_simple_after_school_notice_response_dto.dart';

abstract class AfterSchoolRepository {
  Future<Result<PageSimpleAfterSchoolNoticeResponseDto, String>> getAfterSchoolNotices(int page, int size);
  Future<Result<AfterSchoolDto, String>> getAfterSchoolNotice(int id);
}