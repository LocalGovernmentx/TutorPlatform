import 'package:flutter/material.dart';
import 'package:tutor_platform/core/screen_state.dart';

class MainViewModel with ChangeNotifier {
  ScreenState screenState = const ScreenState.signInUpScreen();

  void onEvent(ScreenState screenState) {
    _changeScreenState(screenState);
  }

  void _changeScreenState(ScreenState screenState) {
    this.screenState = screenState;
    notifyListeners();
  }
}