import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/sign_in_up/presentation/sign_up/email_password/sign_up_email_password_view_model.dart';
import 'package:tutor_platform/sign_in_up/presentation/sign_up/email_password/sign_up_email_password_ui_event.dart';
import 'package:tutor_platform/sign_in_up/presentation/sign_up/user_info/sign_up_user_info_view.dart';
import 'package:tutor_platform/sign_in_up/presentation/sign_up/user_info/sign_up_user_info_view_model.dart';
import 'package:tutor_platform/ui/tutee_theme.dart';
import 'package:tutor_platform/ui/tutor_theme.dart';

class SignUpEmailPasswordView extends StatefulWidget {
  final bool isTutor;

  const SignUpEmailPasswordView({super.key, required this.isTutor});

  @override
  State<SignUpEmailPasswordView> createState() =>
      _SignUpEmailPasswordViewState();
}

class _SignUpEmailPasswordViewState extends State<SignUpEmailPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationCode = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckController =
      TextEditingController();

  int time = 180;
  Timer? _timer;

  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final viewModel = context.read<SignUpEmailPasswordViewModel>();
      _streamSubscription = viewModel.eventStream.listen((uiEvent) {
        SignUpEmailPasswordUiEvent event = uiEvent;
        switch (event) {
          case SignUpUiSendEmailSuccess():
            time = 180;
            _timer?.cancel();
            _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
              setState(() {
                time--;
                if (time == 0) {
                  timer.cancel();
                }
              });
            });
          case SignUpUiEventVerifyCodeSuccess():
            _timer?.cancel();
          case SignUpUiEventNextScreen():
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SignUpUserInfoView(
                    isTutor: widget.isTutor,
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                },
              ),
            );
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
    _passwordCheckController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _verificationCode.dispose();
    _timer?.cancel();
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignUpEmailPasswordViewModel>();

    return Theme(
      data: widget.isTutor ? tutorTheme : tuteeTheme,
      child: PopScope(
        onPopInvoked: (bool didPop) {
          if (didPop) {
            viewModel.clean();

            final nextScreenViewModel = context.read<SignUpUserInfoViewModel>();
            nextScreenViewModel.clean();
          }
        },
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
                    child:
                        Image.asset('assets/icons/right_arrow.png', width: 30),
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
                const Text('이메일'),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: '이메일을 입력해주세요',
                    errorText: viewModel.emailError,
                    helper: viewModel.isEmailValidated
                        ? const Text('성공적으로 인증되었습니다.')
                        : null,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 15),
                      child: SizedBox(
                        height: 48,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (!viewModel.isEmailValidating) {
                                viewModel.requestEmailVerification(
                                    _emailController.text);
                                return;
                              } else if (time <= 0) {
                                const snackBar = SnackBar(
                                  content: Text('인증코드가 만료되었습니다. 다시 요청해주세요.'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                return;
                              } else if (viewModel.isEmailValidating) {
                                viewModel.sendVerificationCode(
                                  _emailController.text,
                                  _verificationCode.text,
                                );
                              }
                            },
                            child: const Text('인증'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (viewModel.isEmailValidating) ...[
                  const SizedBox(height: 15),
                  TextField(
                    controller: _verificationCode,
                    decoration: InputDecoration(
                      hintText: '인증번호를 입력해주세요',
                      errorText: viewModel.verificationcodeError,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 15),
                        child: SizedBox(
                          width: 40,
                          child: Center(
                              child: Text(
                            '${time ~/ 60}:${(time % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          )),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      viewModel.requestEmailVerification(_emailController.text);
                    },
                    child: const Text('인증번호 재전송'),
                  ),
                ],
                const SizedBox(height: 30),
                const Text('비밀번호'),
                TextField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: '비밀번호를 입력해주세요',
                    errorText: viewModel.passwordError,
                  ),
                ),
                const SizedBox(height: 20),
                const Text('비밀번호 확인'),
                TextField(
                  obscureText: true,
                  controller: _passwordCheckController,
                  decoration: InputDecoration(
                    hintText: '비밀번호를 다시 입력해주세요',
                    errorText: viewModel.confirmPasswordError,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      viewModel.nextScreen(
                        _emailController.text,
                        _passwordController.text,
                        _passwordCheckController.text,
                      );
                    },
                    child: const Text('다음으로'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
