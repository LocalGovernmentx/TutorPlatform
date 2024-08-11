import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/core/main_view_model.dart';
import 'package:tutor_platform/core/screen_state.dart';
import 'package:tutor_platform/core/user_info.dart';

class TuteeScreen extends StatelessWidget {
  final UserInfo userInfo;

  const TuteeScreen({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        useMaterial3: true,
      ),
      home: const TmpTuteeScreen(),
    );
  }
}

class TmpTuteeScreen extends StatelessWidget {
  const TmpTuteeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutee Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome'),
            ElevatedButton(
              onPressed: () {
                final viewModel = context.read<MainViewModel>();
                viewModel.onEvent(const ScreenState.signInUpScreenState(false));
              },
              child: const Text('logout'),
            ),
          ],
        ),
      ),
    );
  }
}
