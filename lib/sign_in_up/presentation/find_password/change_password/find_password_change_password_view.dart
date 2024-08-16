import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/change_password/find_password_change_password_ui_event.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/change_password/find_password_change_password_view_model.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/final_screen/find_password_final_screen_view.dart';
import 'package:tutor_platform/core/design/common_style.dart';

class FindPasswordChangePasswordView extends StatefulWidget {
  final String email;
  const FindPasswordChangePasswordView({super.key, required this.email});

  @override
  State<FindPasswordChangePasswordView> createState() => _FindPasswordChangePasswordViewState();
}

class _FindPasswordChangePasswordViewState extends State<FindPasswordChangePasswordView> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final viewModel = context.read<FindPasswordChangePasswordViewModel>();
      _streamSubscription = viewModel.eventStream.listen((uiEvent) {
        FindPasswordChangePasswordUiEvent event = uiEvent;
        switch(event) {
          case FindPasswordChangePasswordUiEventSuccess():
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FindPasswordFinalScreenView(),
              ),
            );
          case FindPasswordChangePasswordUiEventError():
            break;
          case FindPasswordChangePasswordUiEventShowSnackBar():
            final snackBar = SnackBar(content: Text(event.message));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FindPasswordChangePasswordViewModel>();
    return Scaffold(
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
            const Text('비밀번호'),
            SizedBox(
              height: 88,
              child: TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: '비밀번호를 입력해주세요',
                  errorText: viewModel.passwordError,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('비밀번호 확인'),
            SizedBox(
              height: 88,
              child: TextField(
                obscureText: true,
                controller: _passwordConfirmController,
                decoration: InputDecoration(
                  hintText: '비밀번호를 다시 입력해주세요',
                  errorText: viewModel.passwordCheckError,
                ),
              ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              height: 54,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  viewModel.changePassword(widget.email, _passwordController.text, _passwordConfirmController.text);
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
                  Navigator.of(context).pop();
                },
                style: uncheckedButtonStyle,
                child: const Text('이전으로 돌아가기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
