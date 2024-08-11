import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/find_password_event.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/find_password_ui_event.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/validation_code/find_password_validation_code_screen.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/find_password_view_model.dart';

class FindPasswordConfirmEmail extends StatefulWidget {
  const FindPasswordConfirmEmail({super.key});

  @override
  State<FindPasswordConfirmEmail> createState() => _FindPasswordConfirmEmailState();
}

class _FindPasswordConfirmEmailState extends State<FindPasswordConfirmEmail> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  StreamSubscription? _streamSubscription;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    final viewModel = context.read<FindPasswordViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    Future.microtask(() {
      _streamSubscription = viewModel.eventStream.listen((event) {
        switch (event) {
          case FindPasswordSuccess():
            _errorMessage = null;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FindPasswordValidationCodeScreen(
                  email: _emailController.text,
                ),
              ),
            );
          case FindPasswordErrorMessage():
            _errorMessage = event.message;
          case FindPasswordShowSnackBar():
            final snackBar = SnackBar(content: Text(event.message));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          default:
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FindPasswordViewModel>();

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
            const Text('이메일'),
            TextField(
              focusNode: _focusNode,
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: '가입하신 이메일을 입력해주세요',
                border: OutlineInputBorder(),
              ),
            ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  viewModel
                      .onEvent(SendRequestEmailEvent(_emailController.text));
                },
                child: const Text('인증코드 보내기'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('로그인으로 돌아가기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
