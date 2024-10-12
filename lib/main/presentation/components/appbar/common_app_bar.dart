import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final PreferredSizeWidget? tabBar;
  final PageController? pageController;

  const CommonAppBar({
    super.key,
    required this.title,
    required this.actions,
    this.tabBar,
    this.pageController,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight * (tabBar == null ? 1 : 2));

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            onPressed: () {
              if (pageController == null) {
                Navigator.pop(context);
              } else {
                pageController!.jumpToPage(0);
              }
            },
            icon: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(3.141592),
              child: Image.asset('assets/icons/right_arrow.png', width: 30),
            ),
          ),
        ),
        title: Text(title, style: Theme.of(context).textTheme.headlineLarge),
        actions: [
          ...actions,
          const SizedBox(width: 20),
        ],
        bottom: tabBar,
      ),
    );
  }
}
