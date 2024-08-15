import 'package:flutter/material.dart';
import 'package:tutor_platform/ui/tutee_theme.dart';
import 'package:tutor_platform/ui/tutor_theme.dart';

class SignUpFinalScreenView extends StatelessWidget {
  final bool isTutor;
  final String nickName;

  const SignUpFinalScreenView({super.key, required this.isTutor, required this.nickName});

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
                  : 'assets/images/successful_register/tutee.png'),
              Text('$nickName님 가입을 환영합니다.'),
            ],
          ),
        ),
      ),
    );
  }
}
