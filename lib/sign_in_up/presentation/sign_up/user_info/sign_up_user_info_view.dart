import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/core/properties/member_property.dart';
import 'package:tutor_platform/sign_in_up/presentation/sign_up/final_screen/sign_up_final_screen_view.dart';
import 'package:tutor_platform/sign_in_up/presentation/sign_up/user_info/phone_number_formatter.dart';
import 'package:tutor_platform/sign_in_up/presentation/sign_up/user_info/sign_up_user_info_ui_event.dart';
import 'package:tutor_platform/sign_in_up/presentation/sign_up/user_info/sign_up_user_info_view_model.dart';
import 'package:tutor_platform/core/design/font.dart';
import 'package:tutor_platform/core/design/tutee_theme.dart';
import 'package:tutor_platform/core/design/tutor_theme.dart';

class SignUpUserInfoView extends StatefulWidget {
  final bool isTutor;
  final String email;
  final String password;

  const SignUpUserInfoView(
      {super.key,
      required this.isTutor,
      required this.email,
      required this.password});

  @override
  State<SignUpUserInfoView> createState() => _SignUpUserInfoViewState();
}

class _SignUpUserInfoViewState extends State<SignUpUserInfoView> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _invitationCodeController =
      TextEditingController();

  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();

    final viewModel = context.read<SignUpUserInfoViewModel>();

    Future.microtask(() {
      _streamSubscription = viewModel.eventStream.listen((event) {
        switch (event) {
          case SignUpUiEventNicknameVerifySuccess():
            setState(() {});
          case SignUpUiEventSignUpSuccess():
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SignUpFinalScreenView(
                isTutor: widget.isTutor,
                nickName: _nicknameController.text,
              );
            }));
          case SignUpUiEventError():
            setState(() {});
          case SignUpUiEventShowSnackBar():
            final snackBar = SnackBar(content: Text(event.message));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _phoneNumberController.dispose();
    _invitationCodeController.dispose();

    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignUpUserInfoViewModel>();

    return Theme(
      data: widget.isTutor ? tutorTheme : tuteeTheme,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(3.141592),
                  child: Image.asset('assets/icons/right_arrow.png', width: 30),
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Text('회원가입', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text('닉네임'),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 18,
                    child: Image.asset('assets/icons/exclamation_mark.png'),
                  ),
                  Text(
                    '닉네임은 변경할 수 없습니다',
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  hintText: '닉네임을 입력해주세요',
                  errorText: viewModel.nicknameError,
                  helper: viewModel.isNicknameValidated
                      ? const Text('사용할 수 있는 닉네임입니다.')
                      : null,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 15),
                    child: SizedBox(
                      height: 48,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                        child: ElevatedButton(
                          onPressed: () {
                            viewModel.checkNickname(_nicknameController.text);
                          },
                          child: const Text('중복확인'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text('이름'),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: '이름을 입력해주세요',
                  errorText: viewModel.nameError,
                ),
              ),
              const SizedBox(height: 30),
              const Text('성별'),
              SizedBox(
                height: 59,
                child: SegmentedButton(
                  showSelectedIcon: false,
                  segments: const <ButtonSegment>[
                    ButtonSegment(
                      value: MemberProperty.man,
                      label: SizedBox(height: 23,child: Center(child: Text('남자'))),
                    ),
                    ButtonSegment(
                      value: MemberProperty.woman,
                      label: SizedBox(height: 23,child: Center(child: Text('여자'))),
                    ),
                  ],
                  style: SegmentedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  selected: {viewModel.selectedGender},
                  onSelectionChanged: (newSelection) {
                    viewModel.selectedGender = newSelection.first;
                  },
                ),
              ),
              const SizedBox(height: 30),
              const Text('생년월일'),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    ).then((value) {
                      if (value != null) {
                        viewModel.birth = value;
                      }
                    });
                  },
                  child: Text(viewModel.birthString),
                ),
              ),
              if (viewModel.birthDateError != null)
                Text(viewModel.birthDateError!, style: errorTextStyle),
              if (viewModel.isUnder15) ...[
                const SizedBox(height: 30),
                Row(
                  children: [
                    const Text('초대코드'),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 18,
                      child: Image.asset('assets/icons/exclamation_mark.png'),
                    ),
                    Text(
                      '15세 이하는 필수입니다',
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _invitationCodeController,
                  decoration: InputDecoration(
                    hintText: '초대코드를 입력해주세요',
                    errorText: viewModel.invitationCodeError,
                  ),
                ),
              ],
              const SizedBox(height: 30),
              const Text('전화번호'),
              TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(13),
                  PhoneNumberFormatter(),
                ],
                keyboardType: TextInputType.number,
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  hintText: '전화번호를 입력해주세요',
                  errorText: viewModel.phoneNumberError,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    viewModel.register(
                      _nameController.text,
                      widget.password,
                      widget.email,
                      _nicknameController.text,
                      _phoneNumberController.text,
                      _invitationCodeController.text,
                      widget.isTutor,
                    );
                  },
                  child: const Text('완료'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
