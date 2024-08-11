import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tutor_platform/core/main_view_model.dart';
import 'package:tutor_platform/sign_in_up/di/login_provider_setup.dart';
import 'package:tutor_platform/sign_in_up/presentation/login/login_screen.dart';

class SignInUpScreen extends StatelessWidget {
  final bool autoLogin;

  const SignInUpScreen({super.key, required this.autoLogin});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: globalProvidersLogin,
      child: MaterialApp(
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
        home: LoginScreen(autoLogin: autoLogin),
      ),
    );
  }
}
