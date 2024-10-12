import 'package:flutter/material.dart';

class TuteeSearchTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final double height;

  const TuteeSearchTabBar({
    super.key,
    required this.tabController,
    this.height = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      tabs: const [
        Tab(text: '모두의 튜터 과외'),
        Tab(text: '튜터'),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
