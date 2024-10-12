import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/send_code/find_password_send_code_view.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/send_email/find_password_send_email_ui_event.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/send_email/find_password_send_email_view_model.dart';
import 'package:tutor_platform/core/design/style.dart';

class FindPasswordSendEmailView extends StatefulWidget {
  const FindPasswordSendEmailView({super.key});

  @override
  State<FindPasswordSendEmailView> createState() =>
      _FindPasswordSendEmailViewState();
}

class _FindPasswordSendEmailViewState extends State<FindPasswordSendEmailView> {
  final TextEditingController _emailController = TextEditingController();

  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final viewModel = context.read<FindPasswordSendEmailViewModel>();
      _streamSubscription = viewModel.eventStream.listen((uiEvent) {
        FindPasswordSendEmailUiEvent event = uiEvent;
        switch (event) {
          case FindPasswordSendEmailUiEventSuccess():
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FindPasswordSendCodeView(email: _emailController.text.trim()),
              ),
            );
          case FindPasswordSendEmailUiEventError():
            setState(() {});
          case FindPasswordSendEmailUiEventShowSnackBar():
            final snackBar = SnackBar(content: Text(event.message));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FindPasswordSendEmailViewModel>();

    return PopScope(
      onPopInvoked: (bool didPop) {
        if (didPop) {
          viewModel.clear();
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
              const Text('이메일'),
              SizedBox(
                height: 88,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: '가입하신 이메일을 입력해주세요',
                    errorText: viewModel.emailError,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              SizedBox(
                height: 54,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    viewModel.sendEmail(_emailController.text.trim());
                  },
                  child: const Text('인증번호 발송'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 54,
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
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
