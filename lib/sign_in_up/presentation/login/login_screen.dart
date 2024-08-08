import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/core/main_view_model.dart';
import 'package:tutor_platform/core/screen_state.dart';
import 'package:tutor_platform/sign_in_up/presentation/login/login_event.dart';
import 'package:tutor_platform/sign_in_up/presentation/login/login_ui_event.dart';
import 'package:tutor_platform/sign_in_up/presentation/login/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  StreamSubscription? _streamSubscription;
  String? _errorMessagePassword, _errorMessageEmail;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final viewModel = context.read<LoginViewModel>();
      print('object');

      _streamSubscription = viewModel.eventStream.listen((event) {
        switch (event) {
          case Successful():
            final screenState = context.read<MainViewModel>();








            // ToDo: goto tutee screen for tutor screen
            screenState.onEvent(ScreenState.tuteeScreen(event.userInfo));
          case ErrorMessagePassword():
            _errorMessagePassword = event.message;
          case ErrorMessageEmail():
            _errorMessageEmail = event.message;
          case ShowSnackBar():
            final snackBar = SnackBar(content: Text(event.message));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo_with_name.png',
                  width: 200,
                ),
              ),
              const SizedBox(height: 16),
              const Text('e-mail'),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'e-mail을 입력해주세요',
                  border: OutlineInputBorder(),
                ),
              ),
              if (_errorMessageEmail != null)
                Text(
                  _errorMessageEmail!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16),
              const Text('Password'),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '비밀번호를 입력해주세요',
                  border: OutlineInputBorder(),
                ),
              ),
              if (_errorMessagePassword != null)
                Text(
                  _errorMessagePassword!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    viewModel.onEvent(Login(
                      _emailController.text,
                      _passwordController.text,
                    ));
                    
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Login'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('이메일 찾기'),
                  ),
                  const Text(' | '),
                  TextButton(
                    onPressed: () {},
                    child: const Text('비밀번호 찾기'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
