import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowme/screens.dart/splash_screen.dart';
import 'package:wowme/shared/constants.dart';
import 'package:wowme/shared/initial_app_binding.dart';
import 'package:wowme/shared/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WowmeApp());
}

class WowmeApp extends StatelessWidget {
  const WowmeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wowme Call Center',
      getPages: AppRoutes.routes,
      initialBinding: InitialBindings(),
      home: const SplashScreen(),
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
