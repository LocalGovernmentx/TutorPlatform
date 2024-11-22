import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/properties/backend_information.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/main/domain/model/dto/after_school_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/page_simple_after_school_notice_response_dto.dart';
import 'package:tutor_platform/main/domain/model/dto/simple_after_school_notice_response_dto.dart';

class AfterSchoolApiDataSource {
  final http.Client client;

  AfterSchoolApiDataSource(this.client);

  static const baseUrl = '$backendBaseUrl/after-school';

  Future<Result<PageSimpleAfterSchoolNoticeResponseDto, String>> getAfterSchoolNotices(int page, int size) async {
    final url = Uri.parse('$baseUrl?page=$page&size=$size&sort=id');

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final body = json.decode(utf8.decode(response.bodyBytes));
        return Result.success(PageSimpleAfterSchoolNoticeResponseDto.fromJson(body));
      }
      return Result.error('Failed to load lecture');
    } catch (e, stackTrace) {
      print(stackTrace);
      return Result.error(e.toString());
    }
  }

  Future<Result<AfterSchoolDto, String>> getAfterSchoolNotice(int id) async {
    final url = Uri.parse('$baseUrl/$id');

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final body = json.decode(utf8.decode(response.bodyBytes));
        return Result.success(AfterSchoolDto.fromJson(body));
      }
      return Result.error('Failed to load lecture');
    } catch (e, stackTrace) {
      print(stackTrace);
      return Result.error(e.toString());
    }
  }
}