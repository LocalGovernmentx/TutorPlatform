import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/properties/member_property.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/check_nickname.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/sign_up.dart';
import 'package:tutor_platform/sign_in_up/presentation/sign_up/user_info/sign_up_user_info_ui_event.dart';

class SignUpUserInfoViewModel extends ChangeNotifier {
  final CheckNickname _checkNickname;
  final SignUp _signUp;

  final _eventController = StreamController<SignUpUserInfoUiEvent>.broadcast();

  Stream get eventStream => _eventController.stream;

  SignUpUserInfoViewModel(this._checkNickname, this._signUp);

  String? _nicknameError;
  String? _nameError;
  String? _phoneNumberError;
  String? _invitationCodeError;
  String? _birthDateError;

  String? _validatedNickname;
  int _selectedGender = MemberProperty.man;

  DateTime? _birth;
  bool _isUnder15 = false;

  String? get nicknameError => _nicknameError;

  String? get nameError => _nameError;

  String? get phoneNumberError => _phoneNumberError;

  String? get invitationCodeError => _invitationCodeError;

  String? get birthDateError => _birthDateError;

  bool get isNicknameValidated => _validatedNickname != null;

  int get selectedGender => _selectedGender;

  set selectedGender(int value) {
    if (value != MemberProperty.man || value != MemberProperty.woman) {
      _selectedGender = value;
      notifyListeners();
    }
  }

  set birth(DateTime? value) {
    _birth = value;
    _isUnder15 = DateTime.now().year - value!.year < 15;

    notifyListeners();
  }

  get birthString {
    if (_birth == null) {
      return '생년월일을 선택해주세요';
    }
    return '${_birth!.year}년 ${_birth!.month}월 ${_birth!.day}일';
  }

  bool get isUnder15 => _isUnder15;

  List<bool> get isSelectedGenderList => [
        _selectedGender == MemberProperty.man,
        _selectedGender == MemberProperty.woman,
      ];

  @override
  void dispose() {
    _eventController.close();

    super.dispose();
  }

  void clean() {
    _nicknameError = null;
    _nameError = null;
    _phoneNumberError = null;
    _invitationCodeError = null;
    _birthDateError = null;
    _validatedNickname = null;
    _selectedGender = MemberProperty.man;
    _isUnder15 = false;
    _birth = null;
  }

  void checkNickname(String nickname) async {
    _nicknameError = null;
    _validatedNickname = null;
    if (!_validateNickname(nickname)) {
      notifyListeners();
      _eventController.add(SignUpUserInfoUiEvent.error());
      return;
    }

    Result<dynamic, NetworkErrors> result = await _checkNickname(nickname);
    switch (result) {
      case Success<dynamic, NetworkErrors>():
        _validatedNickname = nickname;
        _eventController.add(SignUpUserInfoUiEvent.nicknameVerifySuccess());
      case Error<dynamic, NetworkErrors>():
        _eventController.add(_handleNicknameNetworkError(result.error));
    }
    notifyListeners();
  }

  Future<void> register(
    String name,
    String password,
    String email,
    String nickname,
    String phoneNumber,
    String invitationCode,
    bool isTutor,
  ) async {
    _nicknameError = null;
    _nameError = null;
    _phoneNumberError = null;
    _invitationCodeError = null;
    _birthDateError = null;

    bool validate = true;
    if (_validatedNickname != nickname) {
      validate = false;
      _nicknameError = '닉네임 변경이 감지되었습니다. 다시 중복확인을 해주세요';
    }
    if (_validatedNickname == null) {
      validate = false;
      _nicknameError = '닉네임 중복확인을 해주세요';
    }
    validate = _validateName(name) && validate;
    validate = _validatePhoneNumber(phoneNumber) && validate;
    validate = _validateBirthAndInvitationCode(invitationCode) && validate;
    if (!validate) {
      notifyListeners();
      _eventController.add(SignUpUserInfoUiEvent.error());
      return;
    }

    final Result<String, NetworkErrors> result = await _signUp(
      name,
      password,
      email,
      nickname,
      phoneNumber,
      _selectedGender,
      _birth!,
      _isUnder15 ? invitationCode : '',
      isTutor,
    );

    switch (result) {
      case Success<String, NetworkErrors>():
        _eventController.add(SignUpUserInfoUiEvent.signUpSuccess());
      case Error<String, NetworkErrors>():
        _eventController.add(_handleSignUpNetworkError(result.error));
    }
  }

  SignUpUserInfoUiEvent _handleSignUpNetworkError(NetworkErrors error) {
    switch (error) {
      case TimeoutError():
        return SignUpUserInfoUiEvent.showSnackBar('네트워크가 불안정합니다');
      case ServerError():
        return SignUpUserInfoUiEvent.showSnackBar(
            '${error.statusCode} : 서버 에러가 발생하였습니다');
      case ClientError():
        return SignUpUserInfoUiEvent.showSnackBar(
            '${error.statusCode} : 프런트 구현 에러가 발생하였습니다');
      case UnknownStatusCode():
        return SignUpUserInfoUiEvent.showSnackBar(
            '${error.statusCode} : 에러가 발생하였습니다');
      case CredentialsError():
        final message = error.message;
        if (message == "Nickname must be between 2 and 8 characters long") {
          _nicknameError = '닉네임은 2자 이상 8자 이하이어야 합니다';
          return SignUpUserInfoUiEvent.error();
        }
        if (message == "Email is not verified") {
          return SignUpUserInfoUiEvent.showSnackBar(
              '이메일 인증이 만료되었습니다.\n되돌아가서 이메일 인증을 진행해주세요');
        }
        if (message == "Phone number is already in use") {
          _phoneNumberError = '이미 사용중인 전화번호입니다';
          return SignUpUserInfoUiEvent.error();
        }
        if (message == "Email is already in use") {
          return SignUpUserInfoUiEvent.showSnackBar(
              '이미 사용중인 이메일입니다\n다른 이메일로 다시 회원가입해주세요');
        }
        if (message == "Password is too short") {
          return SignUpUserInfoUiEvent.showSnackBar(
              '비밀번호는 8자 이상이어야 합니다\n되돌아가서 다시 회원가입해주세요');
        }
        if (message == "Invalid email format") {
          return SignUpUserInfoUiEvent.showSnackBar(
              '이메일 형식이 틀렸습니다\n되돌아가서 다시 회원가입해주세요');
        }
        return SignUpUserInfoUiEvent.error();
      case UnknownError():
        return SignUpUserInfoUiEvent.showSnackBar('알 수 없는 오류가 발생하였습니다');
    }
  }

  SignUpUserInfoUiEvent _handleNicknameNetworkError(NetworkErrors error) {
    switch (error) {
      case TimeoutError():
        return SignUpUserInfoUiEvent.showSnackBar('네트워크가 불안정합니다');
      case ServerError():
        return SignUpUserInfoUiEvent.showSnackBar(
            '${error.statusCode} : 서버 에러가 발생하였습니다');
      case ClientError():
        return SignUpUserInfoUiEvent.showSnackBar(
            '${error.statusCode} : 프런트 구현 에러가 발생하였습니다');
      case UnknownStatusCode():
        return SignUpUserInfoUiEvent.showSnackBar(
            '${error.statusCode} : 에러가 발생하였습니다');
      case CredentialsError():
        if (error.message == 'Nickname is already in use') {
          _nicknameError = '이미 사용중인 닉네임입니다';
          return SignUpUserInfoUiEvent.error();
        }
        return SignUpUserInfoUiEvent.showSnackBar(error.message);
      case UnknownError():
        return SignUpUserInfoUiEvent.showSnackBar('알 수 없는 오류가 발생하였습니다');
    }
  }

  bool _validateNickname(String nickname) {
    if (nickname.isEmpty) {
      _nicknameError = '닉네임을 입력해주세요';
      return false;
    }
    if (nickname.length < MemberProperty.minNicknameLength) {
      _nicknameError = '닉네임은 ${MemberProperty.minNicknameLength}자 이상이어야 합니다';
      return false;
    }
    if (nickname.length > MemberProperty.maxNicknameLength) {
      _nicknameError = '닉네임은 ${MemberProperty.maxNicknameLength}자 이하이어야 합니다';
      return false;
    }
    return true;
  }

  bool _validateName(String name) {
    if (name.isEmpty) {
      _nameError = '이름을 입력해주세요';
      return false;
    }
    if (name.length < MemberProperty.minNameLength) {
      _nameError = '이름은 ${MemberProperty.minNameLength}자 이상이어야 합니다';
      return false;
    }
    if (name.length > MemberProperty.maxNameLength) {
      _nameError = '이름은 ${MemberProperty.maxNameLength}자 이하이어야 합니다';
      return false;
    }
    return true;
  }

  bool _validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      _phoneNumberError = '전화번호를 입력해주세요';
      return false;
    }
    if (phoneNumber.length < MemberProperty.minPhoneNumberLength) {
      _phoneNumberError =
          '전화번호는 ${MemberProperty.minPhoneNumberLength}자 이상이어야 합니다';
      return false;
    }
    if (phoneNumber.length > MemberProperty.maxPhoneNumberLength) {
      _phoneNumberError =
          '전화번호는 ${MemberProperty.maxPhoneNumberLength}자 이하이어야 합니다';
      return false;
    }
    return true;
  }

  bool _validateBirthAndInvitationCode(String invitationCode) {
    if (_birth == null) {
      _birthDateError = '생년월일을 선택해주세요';
      return false;
    }
    if (_isUnder15 && invitationCode.isEmpty) {
      _invitationCodeError = '초대 코드를 입력해주세요';
      return false;
    }
    if (_isUnder15 && invitationCode.length < MemberProperty.minInviteCodeLength) {
      _invitationCodeError =
          '초대 코드는 ${MemberProperty.minInviteCodeLength}자 이상이어야 합니다';
      return false;
    }
    if (_isUnder15 && invitationCode.length > MemberProperty.maxInviteCodeLength) {
      _invitationCodeError =
          '초대 코드는 ${MemberProperty.maxInviteCodeLength}자 이하이어야 합니다';
      return false;
    }
    return true;
  }
}
