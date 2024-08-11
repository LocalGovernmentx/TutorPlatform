import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/change_password/find_password_change_screen.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/find_password_event.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/find_password_ui_event.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/find_password_view_model.dart';

class FindPasswordValidationCodeScreen extends StatefulWidget {
  final String email;

  const FindPasswordValidationCodeScreen({super.key, required this.email});

  @override
  State<FindPasswordValidationCodeScreen> createState() =>
      _FindPasswordValidationCodeScreenState();
}

class _FindPasswordValidationCodeScreenState
    extends State<FindPasswordValidationCodeScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _validationCodeController =
      TextEditingController();
  StreamSubscription? _streamSubscription;
  String? _errorMessage;

  Timer? _timer;
  int time = 180;

  bool validationCodeExpired = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    final viewModel = context.read<FindPasswordViewModel>();

    Future.microtask(() {
      _streamSubscription = viewModel.eventStream.listen((event) {
        switch (event) {
          // ShowSnackBar is considered in find_password_screen
          case FindPasswordValidationSuccess():
            _errorMessage = null;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FindPasswordChangeScreen(
                  email: widget.email,
                ),
              ),
            );
          case FindPasswordValidationError():
            _errorMessage = event.message;
          default:
            break;
        }
      });
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        time--;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _validationCodeController.dispose();
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FindPasswordViewModel>();
    if (time <= 0) {
      _timer?.cancel();
      validationCodeExpired = true;
      time = 0;
    }

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
            const SizedBox(height: 8),
            Text('${widget.email}로 인증코드를 보냈습니다.'),
            const Text('이메일을 확인해주십시오'),
            const SizedBox(height: 16),
            const Text('인증코드'),
            TextField(
              focusNode: _focusNode,
              controller: _validationCodeController,
              decoration: InputDecoration(
                hintText: '인증코드를 입력해주세요',
                border: const OutlineInputBorder(),
                suffix: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '${time ~/ 60}:${(time % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
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
                  if (validationCodeExpired) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('인증코드가 만료되었습니다. 다시 요청해주세요.'),
                      ),
                    );
                    return;
                  }
                  viewModel.onEvent(
                    SendVerificationCodeEvent(
                      widget.email,
                      _validationCodeController.text,
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
