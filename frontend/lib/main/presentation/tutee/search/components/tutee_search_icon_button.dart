import 'package:flutter/material.dart';

class SearchIconButton extends StatelessWidget {
  const SearchIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset('assets/icons/magnifying_glass.png', width: 25),
      onPressed: () {
      },
    );
  }
}