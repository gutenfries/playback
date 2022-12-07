import 'dart:async';

import 'package:flutter/material.dart';
import 'package:playback/routes/routes.dart';
import 'package:playback/utils/navigation.dart';
import 'package:playback/utils/style.dart';

class SplashScreen extends StatelessWidget {
  final duration = const Duration(seconds: 3);

  SplashScreen({Key? key}) : super(key: key) {
    handleOnInitialize();
  }

  void handleOnInitialize() async {
    Future.delayed(duration).then((_) {
      Navigator.pushNamed(
        Navigation.getContext(),
        Routes.welcomeScreen,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: orangeColor,
      body: SafeArea(
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
            height: 180,
          ),
        ),
      ),
    );
  }
}
