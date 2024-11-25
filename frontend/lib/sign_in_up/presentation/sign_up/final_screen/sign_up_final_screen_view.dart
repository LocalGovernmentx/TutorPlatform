import 'package:flutter/material.dart';
import 'package:tutor_platform/sign_in_up/presentation/login/login_view.dart';
import 'package:tutor_platform/core/design/tutee_theme.dart';
import 'package:tutor_platform/core/design/tutor_theme.dart';

class SignUpFinalScreenView extends StatelessWidget {
  final bool isTutor;
  final String nickName;

  const SignUpFinalScreenView(
      {super.key, required this.isTutor, required this.nickName});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: isTutor ? tutorTheme : tuteeTheme,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(isTutor
                  ? 'assets/images/successful_register/tutor.png'
                  : 'assets/images/successful_register/tutee.png',
              width: 180),
              const SizedBox(height: 40),
              Text('가입 완료',
                  style: TextStyle(
                      color: isTutor
                          ? tutorTheme.primaryColor
                          : tuteeTheme.primaryColor)),
              const SizedBox(height: 8),
              Text('$nickName님 가입을 환영합니다.',
                  style: Theme.of(context).textTheme.headlineLarge),
            ],
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const LoginView();
                }));
              },
              child: const Text('로그인'),
            ),
          ),
        ),
      ),
    );
  }
}
