import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/core/main_view_model.dart';
import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/models/user_info.dart';
import 'package:tutor_platform/core/properties/member_property.dart';
import 'package:tutor_platform/core/screen_state.dart';
import 'package:tutor_platform/main/domain/use_case/handling_user_info.dart';

class MainPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isTutor;

  const MainPageAppBar({super.key, required this.isTutor});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: AppBar(
          title: Image.asset('assets/images/logo_with_name.png', width: 164),
          actions: [
            SizedBox(
              width: 72,
              height: 26,
              child: OutlinedButton(
                onPressed: () {
                  final handleUserInfo = context.read<HandlingUserInfo>();
                  JwtToken jwtToken = handleUserInfo.jwtToken;
                  UserInfo curUserInfo = handleUserInfo.userInfo;
                  UserInfo nextUserInfo = curUserInfo.copyWith(
                    type: isTutor
                        ? MemberProperty.tuteeType
                        : MemberProperty.tutorType,
                  );

                  final mainViewModel = context.read<MainViewModel>();
                  mainViewModel.onEvent(
                    isTutor
                        ? ScreenState.tuteeScreenState(jwtToken, nextUserInfo)
                        : ScreenState.tutorScreenState(jwtToken, nextUserInfo),
                  );
                },
                child: isTutor ? const Text('튜티 mode') : const Text('튜터 mode'),
              ),
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon: Image.asset('assets/icons/notification.png', width: 30),
            // ),
          ],
        ),
      ),
    );
  }
}
