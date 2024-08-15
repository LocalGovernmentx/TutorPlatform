import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/core/main_view_model.dart';
import 'package:tutor_platform/core/screen_state.dart';
import 'package:tutor_platform/core/models/jwt_token.dart';

class TuteeScreen extends StatelessWidget {
  final JwtToken jwtToken;

  const TuteeScreen({super.key, required this.jwtToken});

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
            Text(jwtToken.accessToken),
            Text(jwtToken.refreshToken),
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