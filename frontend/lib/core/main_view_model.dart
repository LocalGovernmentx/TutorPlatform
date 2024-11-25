import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_platform/core/screen_state.dart';

class MainViewModel with ChangeNotifier {
  ScreenState screenState = const ScreenState.signInUpScreenState(true);
  final http.Client client;

  MainViewModel(this.client);

  @override
  void dispose() {
    client.close();
    super.dispose();
  }

  void onEvent(ScreenState screenState) {
    _changeScreenState(screenState);
  }

  void _changeScreenState(ScreenState screenState) {
    this.screenState = screenState;
    notifyListeners();
  }
}