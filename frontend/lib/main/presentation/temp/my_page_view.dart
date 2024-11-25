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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/default/default_profile_image.png',
                      width: 100,
                      height: 100,
                    ),
                  ),

                ],
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                final viewModel = context.read<MainViewModel>();
                viewModel.onEvent(const ScreenState.signInUpScreenState(false));
              },
              child: Text('로그아웃', style: Theme.of(context).textTheme.bodyLarge),
            ),
            // const SizedBox(height: 10),
            // TextButton(
            //   onPressed: () {
            //     showDialog(context: context, builder: (context) {
            //       return AlertDialog(
            //         title: const Text('회원탈퇴'),
            //         content: const Text('정말로 탈퇴하시겠습니까?'),
            //         actions: [
            //           TextButton(
            //             onPressed: () {
            //               Navigator.pop(context);
            //             },
            //             child: const Text('취소'),
            //           ),
            //           TextButton(
            //             onPressed: () {
            //               viewModel.deleteUser();
            //               Navigator.pop(context);
            //             },
            //             child: const Text('확인', style: TextStyle(color: Colors.red),),
            //           ),
            //         ],
            //       );
            //     });
            //   },
            //   child: const Text('회원탈퇴', style: TextStyle(color: Colors.red),),
            // ),
          ],
        ),
      ),
    );
  }
}
