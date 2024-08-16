import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/main_view_model.dart';
import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/core/screen_state.dart';
import 'package:tutor_platform/sign_in_up/presentation/auto_login_view_model.dart';
import 'package:tutor_platform/sign_in_up/presentation/login/login_view.dart';
import 'package:tutor_platform/sign_in_up/presentation/sign_up/email_password/sign_up_email_password_view.dart';
import 'package:tutor_platform/sign_in_up/presentation/sign_up/user_info/sign_up_user_info_view.dart';
import 'package:tutor_platform/core/design/colors.dart';

class AutoLoginView extends StatefulWidget {
  final bool autoLogin;

  const AutoLoginView({super.key, required this.autoLogin});

  @override
  State<AutoLoginView> createState() => _AutoLoginViewState();
}

class _AutoLoginViewState extends State<AutoLoginView> {
  @override
  void initState() {
    super.initState();

    AutoLoginViewModel viewModel = context.read<AutoLoginViewModel>();
    if (widget.autoLogin) {
      viewModel.autoLogin().then((Result<JwtToken, dynamic> result) {
        switch (result) {
          case Success<JwtToken, dynamic>():
            final mainViewModel = context.read<MainViewModel>();
            mainViewModel.onEvent(
              ScreenState.tuteeScreenState(result.value),
            );

          case Error<JwtToken, dynamic>():
            if (result.error.isEmpty) {
              return;
            }
            const snackBar = SnackBar(content: Text('자동로그인이 실패하였습니다.'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } else {
      viewModel.removeRememberMe();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('가입 유형을 선택해주세요.',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 38),
            SizedBox(
              width: double.infinity,
              height: 131,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: tuteeSecondaryColor,
                  foregroundColor: contentTextColor,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const SignUpEmailPasswordView(isTutor: false)));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('학생 / 학부모님',
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 10),
                        const Text('강의를 등록하거나 학생을 가르칠\n 선생님이시면 선택해주세요'),
                      ],
                    ),
                    Image.asset(
                        'assets/images/starting_screen/tutee_character.png',
                        width: 91),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 13),
            SizedBox(
              width: double.infinity,
              height: 131,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: tutorSecondaryColor,
                  foregroundColor: contentTextColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const SignUpEmailPasswordView(isTutor: true),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('선생님',
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 10),
                        const Text('강의를 등록하거나 학생을 가르칠\n 선생님이시면 선택해주세요'),
                      ],
                    ),
                    Image.asset(
                        'assets/images/starting_screen/tutor_character.png',
                        width: 91),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 39),
            const Text('이미 아이디가 있습니다'),
            const SizedBox(height: 15),
            TextButton(
              child: const Text(
                '로그인하러 가기',
                style: TextStyle(
                  color: Color(0xFF1876FB),
                  decoration: TextDecoration.underline,
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginView()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
