import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/core/main_view_model.dart';
import 'package:tutor_platform/core/screen_state.dart';
import 'package:tutor_platform/main/presentation/components/appbar/common_app_bar.dart';
import 'package:tutor_platform/main/presentation/temp/my_page_view_model.dart';

class MyPageView extends StatelessWidget {
  final PageController? pageController;
  const MyPageView({super.key, this.pageController});

  @override
  Widget build(BuildContext context) {
    final myPageViewModel = context.read<MyPageViewModel>();

    return Scaffold(
      appBar: CommonAppBar(
        title: '마이페이지',
        actions: const [],
        pageController: pageController,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome'),
            Text(myPageViewModel.jwtToken.accessToken),
            Text(myPageViewModel.jwtToken.refreshToken),
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
