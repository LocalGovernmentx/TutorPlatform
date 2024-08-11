import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/find_password_event.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/find_password_ui_event.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/find_password_view_model.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/successful/find_password_successful.dart';

class FindPasswordChangeScreen extends StatefulWidget {
  final String email;
  const FindPasswordChangeScreen({super.key, required this.email});

  @override
  State<FindPasswordChangeScreen> createState() => _FindPasswordChangeScreenState();
}

class _FindPasswordChangeScreenState extends State<FindPasswordChangeScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckController = TextEditingController();
  String? _passwordErrorMessage, _passwordCheckErrorMessage;
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();

    final viewModel = context.read<FindPasswordViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    Future.microtask(() {
      _streamSubscription = viewModel.eventStream.listen((event) {
        switch(event) {
          // ShowSnackBar is considered in find_password_screen
          case ChangePasswordSuccess():
            _passwordErrorMessage = null;
            _passwordCheckErrorMessage = null;
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FindPasswordSuccessful(
                  email: widget.email,
                ),
              ),
            );
          case PasswordErrorMessage():
            _passwordErrorMessage = event.message;
          case PasswordCheckErrorMessage():
            _passwordCheckErrorMessage = event.message;
          default:
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordCheckController.dispose();
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
            const Text('새 비밀번호'),
            TextField(
              focusNode: _focusNode,
              obscureText: true,
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: '새 비밀번호를 입력해주세요',
                border: OutlineInputBorder(),
              ),
            ),
            if (_passwordErrorMessage != null)
              Text(
                _passwordErrorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
            const Text('새 비밀번호 확인'),
            TextField(
              obscureText: true,
              controller: _passwordCheckController,
              decoration: const InputDecoration(
                hintText: '새 비밀번호를 다시 입력해주세요',
                border: OutlineInputBorder(),
              ),
            ),
            if (_passwordCheckErrorMessage != null)
              Text(
                _passwordCheckErrorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  viewModel.onEvent(
                    ChangePasswordEvent(
                      widget.email,
                      _passwordController.text,
                      _passwordCheckController.text,
                    ),
                  );
                },
                child: const Text('비밀번호 바꾸기'),
              ),
            ),
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
    );
  }
}
