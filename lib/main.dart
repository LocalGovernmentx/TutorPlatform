import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tutor_platform/core/di/main_provider_setup.dart';
import 'package:tutor_platform/core/main_view_model.dart';
import 'package:tutor_platform/core/screen_state.dart';
import 'package:tutor_platform/sign_in_up/di/login_provider_setup.dart';
import 'package:tutor_platform/sign_in_up/presentation/login/login_screen.dart';

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
      case SignInUpScreen():
        return FutureBuilder<List<SingleChildWidget>>(
            future: getProvidersLogin(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Error occurred');
              } else {
                return MultiProvider(
                    providers: snapshot.data!,
                    child: const TutorPlatformLogin());
              }
            });
      case TuteeScreen():
        return const Placeholder();
      case TutorScreen():
        return const Placeholder();
    }
  }
}

class TutorPlatformLogin extends StatelessWidget {
  const TutorPlatformLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
