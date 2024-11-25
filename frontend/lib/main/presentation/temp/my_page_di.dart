import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/domain/use_case/handling_user_info.dart';
import 'package:tutor_platform/main/presentation/temp/my_page_view.dart';
import 'package:tutor_platform/main/presentation/temp/my_page_view_model.dart';

class MyPageDi extends StatelessWidget {
  const MyPageDi({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyPageViewModel>(
      create: (context) => MyPageViewModel(context.read<HandlingUserInfo>()),
      child: MyPageView(),
    );
  }
}
