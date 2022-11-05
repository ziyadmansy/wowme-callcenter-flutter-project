import 'dart:async';
import 'dart:ui';

import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:wowme/controllers/auth_controller.dart';
import 'package:wowme/controllers/calls_controller.dart';
import 'package:wowme/screens.dart/splash_screen.dart';
import 'package:wowme/shared/constants.dart';
import 'package:wowme/shared/initial_app_binding.dart';
import 'package:wowme/shared/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await validatePhonePermissions();

  // await initializeBackgroundService();
  runApp(const WowmeApp());
}

Future<void> validatePhonePermissions() async {
  final Telephony telephony = Telephony.instance;

  final isPhonePermissionsGranted = await telephony.requestPhonePermissions;

  // Just to request Call logs permission as it crashes the app at first time
  await CallLog.get();

  print('SMS Permission: $isPhonePermissionsGranted');
}

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      autoStartOnBoot: true,
      initialNotificationTitle: 'Wowme',
      initialNotificationContent: 'Wowme call logs service running',
    ),
    iosConfiguration: IosConfiguration(),
  );

  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
  });

  Timer.periodic(
    const Duration(seconds: 15),
    (timer) async {
      // It has to be registered in the service as the service doesn't communicate with the outside app
      if (!Get.isRegistered<AuthController>()) {
        Get.put(AuthController());
      }
      final callsController = Get.isRegistered<CallsController>()
          ? Get.find<CallsController>()
          : Get.put(CallsController());
      final currentCallState = await callsController.checkCallState();
      if (currentCallState == CallState.RINGING ||
          currentCallState == CallState.OFFHOOK) {
        // In case the phone is ringing(CallState.RINGING)
        // Or case the phone is in call(CallState.OFFHOOK)
        callsController.noOfLogsMsg.value =
            '${callsController.noOfLogsMsg.value}\n${currentCallState.name}';
        return;
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print(prefs.getString(accessTokenPrefsKey));
        await submitCallLogs();
      }
    },
  );
}

Future<void> submitCallLogs() async {
  final callsController = Get.find<CallsController>();
  Iterable<CallLogEntry> entries = await CallLog.get();

  await callsController.submitCallLogs(entries.toList(), isBackground: true);
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
