import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowme/screens.dart/home_screen.dart';
import 'package:wowme/screens.dart/login_screen.dart';

class AppRoutes {
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.homeRoute,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.loginRoute,
      page: () => const LoginScreen(),
    ),
  ];
}
