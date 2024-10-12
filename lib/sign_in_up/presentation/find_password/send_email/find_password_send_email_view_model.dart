import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/request_email_verification_yes_duplicate.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/send_email/find_password_send_email_ui_event.dart';

class FindPasswordSendEmailViewModel extends ChangeNotifier {
  final RequestEmailVerificationYesDuplicate
      _requestEmailVerificationYesDuplicate;

  final _eventController =
      StreamController<FindPasswordSendEmailUiEvent>.broadcast();

  Stream get eventStream => _eventController.stream;

  FindPasswordSendEmailViewModel(this._requestEmailVerificationYesDuplicate);

  String? _emailError;

  String? get emailError => _emailError;

  @override
  void dispose() {
    _eventController.close();

    super.dispose();
  }

  void sendEmail(String email) async {
    email = email.trim();
    _emailError = null;
    if (!_validateEmail(email)) {
      _eventController.add(FindPasswordSendEmailUiEvent.error());
      notifyListeners();
      return;
    }

    final Result<dynamic, NetworkErrors> result =
        await _requestEmailVerificationYesDuplicate(email);
    switch (result) {
      case Success<dynamic, NetworkErrors>():
        _eventController.add(FindPasswordSendEmailUiEvent.success());
      case Error<dynamic, NetworkErrors>():
        _eventController.add(_handleNetworkError(result.error));
    }
    notifyListeners();
  }

  bool _validateEmail(String email) {
    if (email.isEmpty) {
      _emailError = '이메일을 입력해주세요';
      return false;
    }
    if (!(RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email))) {
      _emailError = '이메일 형식이 올바르지 않습니다';
      return false;
    }
    if (email.length > 320) {
      _emailError = '이메일은 320자 이하이어야 합니다';
      return false;
    }
    return true;
  }

  FindPasswordSendEmailUiEvent _handleNetworkError(NetworkErrors error) {
    switch (error) {
      case TimeoutError():
        return FindPasswordSendEmailUiEvent.showSnackBar('네트워크가 불안정합니다');
      case ServerError():
        return FindPasswordSendEmailUiEvent.showSnackBar(
            '${error.statusCode} : 서버 오류가 발생했습니다');
      case ClientError():
        return FindPasswordSendEmailUiEvent.showSnackBar(
            '${error.statusCode} : 클라이언트 오류가 발생했습니다');
      case UnknownStatusCode():
        return FindPasswordSendEmailUiEvent.showSnackBar(
            '${error.statusCode} : 알 수 없는 오류가 발생했습니다');
      case CredentialsError():
        if (error.message == 'Email is available') {
          _emailError = '가입되지 않은 이메일입니다';
          return FindPasswordSendEmailUiEvent.error();
        }
        if (error.message == 'Invalid email format') {
          _emailError = '이메일 형식이 올바르지 않습니다';
          return FindPasswordSendEmailUiEvent.error();
        }
        return FindPasswordSendEmailUiEvent.showSnackBar(error.message);
      case UnknownError():
        return FindPasswordSendEmailUiEvent.showSnackBar('알 수 없는 오류가 발생했습니다');
    }
  }

  void clear() {
    _emailError = null;
  }
}
