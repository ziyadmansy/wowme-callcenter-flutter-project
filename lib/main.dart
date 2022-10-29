import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony/telephony.dart';
import 'package:wowme/screens.dart/splash_screen.dart';
import 'package:wowme/shared/constants.dart';
import 'package:wowme/shared/initial_app_binding.dart';
import 'package:wowme/shared/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await validatePhonePermissions();
  runApp(const WowmeApp());
}

Future<void> validatePhonePermissions() async {
  final Telephony telephony = Telephony.instance;

  final isPhonePermissionsGranted = await telephony.requestPhonePermissions;

  print('SMS Permission: $isPhonePermissionsGranted');
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
