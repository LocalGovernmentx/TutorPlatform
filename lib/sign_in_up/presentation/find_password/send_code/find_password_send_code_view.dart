import 'package:flutter/material.dart';
import 'package:tutor_platform/ui/common_style.dart';

class FindPasswordSendCodeView extends StatelessWidget {
  final String email;
  const FindPasswordSendCodeView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) {
        if (didPop) {
          // viewModel clean
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
              Text('비밀번호 찾기', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 30),
              Text('$email로 인증코드를 보냈습니다.'),
              const Text('이메일을 확인해주십시오'),
              const Text('이메일'),
              SizedBox(
                height: 88,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '가입하신 이메일을 입력해주세요',
                  ),
                ),
              ),
              const SizedBox(height: 36),
              SizedBox(
                height: 54,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const FindPasswordSendCodeView(),
                    //   ),
                    // );
                  },
                  child: const Text('비밀번호 바꾸기'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 54,
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                  },
                  style: uncheckedButtonStyle,
                  child: const Text('로그인으로 돌아가기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
