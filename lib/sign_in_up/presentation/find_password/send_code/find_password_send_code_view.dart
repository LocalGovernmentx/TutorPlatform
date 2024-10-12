import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/change_password/find_password_change_password_view.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/send_code/find_password_send_code_ui_event.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/send_code/find_password_send_code_view_model.dart';
import 'package:tutor_platform/core/design/style.dart';

class FindPasswordSendCodeView extends StatefulWidget {
  final String email;

  const FindPasswordSendCodeView({super.key, required this.email});

  @override
  State<FindPasswordSendCodeView> createState() =>
      _FindPasswordSendCodeViewState();
}

class _FindPasswordSendCodeViewState extends State<FindPasswordSendCodeView> {
  final TextEditingController _codeController = TextEditingController();

  int time = 180;
  Timer? _timer;

  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        time--;
        if (time == 0) {
          timer.cancel();
        }
      });
    });

    Future.microtask(() {
      final viewModel = context.read<FindPasswordSendCodeViewModel>();
      _streamSubscription = viewModel.eventStream.listen((uiEvent) {
        FindPasswordSendCodeUiEvent event = uiEvent;
        switch (event) {
          case FindPasswordSendCodeSuccess():
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FindPasswordChangePasswordView(email: widget.email),
              ),
            );
          case FindPasswordSendCodeError():
            break;
          case FindPasswordSendCodeShowSnackBar():
            final snackBar = SnackBar(content: Text(event.message));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FindPasswordSendCodeViewModel>();

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
              Text('인증코드를 보냈습니다.\n이메일을 확인해주십시오.',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 15),
              const Text('인증코드'),
              SizedBox(
                height: 88,
                child: TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    hintText: '인증코드를 입력해주세요',
                    errorText: viewModel.codeError,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 15),
                      child: SizedBox(
                        width: 40,
                        height: 20,
                        child: Center(
                          child: Text(
                            '${time ~/ 60}:${(time % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              SizedBox(
                height: 54,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (time == 0) {
                      viewModel.timeOut();
                    }
                    else {
                      viewModel.sendCode(widget.email, _codeController.text);
                    }
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
      ),
    );
  }
}
