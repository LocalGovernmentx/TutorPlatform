import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/core/di/main_provider_setup.dart';
import 'package:tutor_platform/core/main_view_model.dart';
import 'package:tutor_platform/core/screen_state.dart';
import 'package:tutor_platform/sign_in_up/di/login_provider_setup.dart';
import 'package:tutor_platform/sign_in_up/presentation/auto_login_view.dart';
import 'package:tutor_platform/tutee/presentation/tutee_screen.dart';
import 'package:tutor_platform/tutor/presentation/tutor_screen.dart';
import 'package:tutor_platform/core/design/tutee_theme.dart';
import 'package:tutor_platform/core/design/tutor_theme.dart';

void main() async {
  final providers = globalProvidersMain;
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
        return MultiProvider(
          providers: globalProvidersLogin,
          child: MaterialApp(
            title: 'Tutor Platform',
            theme: tutorTheme,
            home: AutoLoginView(autoLogin: screenState.autoLogin),
          ),
        );
      case TuteeScreenState():
        return MaterialApp(
          title: 'Tutor Platform',
          theme: tutorTheme,
          home: TuteeScreen(jwtToken: screenState.jwtToken),
        );
      case TutorScreenState():
        return MaterialApp(
          title: 'Tutor Platform',
          theme: tuteeTheme,
          home: const TutorScreen(),
        );
    }
  }
}
