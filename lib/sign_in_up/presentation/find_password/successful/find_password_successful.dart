import 'package:flutter/material.dart';

class FindPasswordSuccessful extends StatelessWidget {
  final String email;
  const FindPasswordSuccessful({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '비밀번호 찾기',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text('$email의 비밀번호가 성공적으로 변경되었습니다.'),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('로그인으로 돌아가기'),
              ),
            ),
          ],
        ),
      ),
    );;
  }
}
