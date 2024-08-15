import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/main_view_model.dart';
import 'package:tutor_platform/core/screen_state.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/send_email/find_password_send_email_view.dart';
import 'package:tutor_platform/sign_in_up/presentation/login/login_ui_event.dart';
import 'package:tutor_platform/sign_in_up/presentation/login/login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final viewModel = context.read<LoginViewModel>();
      _streamSubscription = viewModel.eventStream.listen((event) {
        switch (event) {
          case LoginUiEventSuccess():
            Navigator.pop(context);
            final mainViewModel = context.read<MainViewModel>();
            mainViewModel.onEvent(ScreenState.tuteeScreenState(event.jwtToken));
          case LoginUiEventError():
            setState(() {});
          case LoginUiEventShowSnackBar():
            final snackBar = SnackBar(content: Text(event.message));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Image.asset('assets/images/logo_with_name.png',
                    width: 164)),
            const SizedBox(height: 65),
            const Text('e-mail'),
            SizedBox(
              height: 88,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'e-mail을 입력해주세요',
                  errorText: viewModel.emailError,
                ),
              ),
            ),
            const Text('Password'),
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
            const SizedBox(height: 36),
            SizedBox(
              height: 54,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  viewModel.login(
                      _emailController.text, _passwordController.text);
                },
                child: const Text('로그인'),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('회원가입'),
                ),
                const Text(' | '),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const FindPasswordSendEmailView();
                    }));
                  },
                  child: const Text('비밀번호 찾기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
