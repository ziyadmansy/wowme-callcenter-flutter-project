import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wowme/controllers/auth_controller.dart';
import 'package:wowme/shared/constants.dart';
import 'package:wowme/shared/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 1),
      () async {
        final authController = Get.find<AuthController>();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final savedAccessToken = prefs.getString(accessTokenPrefsKey);
        if (savedAccessToken == null || savedAccessToken.isEmpty) {
          Get.offNamed(AppRoutes.loginRoute);
        } else {
          authController.accessToken.value = savedAccessToken;
          Get.offNamed(AppRoutes.homeRoute);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ClipOval(
          child: Image.asset(
            appLogoPath,
            width: MediaQuery.of(context).size.width / 1.5,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
