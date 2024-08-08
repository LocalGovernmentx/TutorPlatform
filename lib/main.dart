import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/core/di/main_provider_setup.dart';
import 'package:tutor_platform/core/main_view_model.dart';
import 'package:tutor_platform/core/screen_state.dart';
import 'package:tutor_platform/sign_in_up/presentation/sign_in_up_screen.dart';
import 'package:tutor_platform/tutee/presentation/tutee_screen.dart';
import 'package:tutor_platform/tutor/presentation/tutor_screen.dart';

void main() async {
  final providers = await getProvidersMain();
  runApp(MultiProvider(
    providers: providers,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final screenState = context.watch<MainViewModel>().screenState;

    switch (screenState) {
      case SignInUpScreenState():
        return SignInUpScreen(autoLogin: screenState.autoLogin);
      case TuteeScreenState():
        return TuteeScreen(userInfo: screenState.userInfo);
      case TutorScreenState():
        return const TutorScreen();
    }
  }
}
