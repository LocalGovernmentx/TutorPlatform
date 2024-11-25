import 'package:flutter/material.dart';
import 'package:tutor_platform/sign_in_up/presentation/login/login_view.dart';

class FindPasswordFinalScreenView extends StatelessWidget {
  const FindPasswordFinalScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('비밀번호가 성공적으로 변경되었습니다',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const LoginView();
                    }));
                  },
                  child: const Text('로그인하러 가기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
