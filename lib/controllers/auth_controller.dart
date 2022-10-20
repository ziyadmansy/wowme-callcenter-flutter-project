import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wowme/shared/api_routes.dart';
import 'package:wowme/shared/constants.dart';
import 'package:wowme/shared/routes.dart';
import 'package:wowme/shared/shared_core.dart';

class AuthController extends GetConnect {
  Rx<String> accessToken = ''.obs;

  /*Future<void> registerUser({
    required String name,
    required String walletPhone,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      const url = ApiRoutes.register;
      print(url);

      final deviceInfoController = Get.find<DeviceInfoController>();
      final deviceInfoData = await deviceInfoController.getDeviceInfoData();

      final firebaseController = Get.find<FirebaseController>();
      final fcmToken = await firebaseController.getFcmToken();

      String formatedPhone = walletPhone.replaceAll('+', '');
      formatedPhone = formatedPhone.startsWith("0", 0)
          ? formatedPhone
          : formatedPhone.substring(1);

      print('Formated Phone: $formatedPhone');

      final Response response = await post(
        url,
        json.encode({
          'name': name,
          'app_lang': 'en',
          'main_wallet_phone': walletPhone,
          'phone': formatedPhone,
          'fcm_token': fcmToken,
          'uuid': deviceInfoData.id,
          'os': deviceInfoData.os,
          'os_version': deviceInfoData.osVersion,
          'model': deviceInfoData.model,
        }),
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        // Success - Account Created
        final decodedResponseBody = response.body;
        accessToken.value = 'Bearer ${decodedResponseBody['access_token']}';
        await prefs.setString(accessTokenPrefsKey, accessToken.value);
        Get.snackbar('Success!', 'Account Created Successfully');
      } else {
        throw AuthException('Error - ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }*/

  Future<void> loginUser(
      {required String email, required String password}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      const url = ApiRoutes.login;
      print(url);

      final Response response = await post(
        url,
        json.encode({
          'email': email,
          'password': password,
        }),
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        // Success - Account Created
        final decodedResponseBody = response.body;
        accessToken.value = 'Bearer ${decodedResponseBody['access_token']}';
        await prefs.setString(accessTokenPrefsKey, accessToken.value);
        Get.snackbar('Success!', 'Logged in successfully');
        Get.offNamed(AppRoutes.homeRoute);
      } else {
        throw Exception('Error - ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> logoutUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      const url = ApiRoutes.logout;
      print(url);

      final Response response = await post(
        url,
        {},
        headers: {
          'Authorization': SharedCore.getAccessToken().value,
        },
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        accessToken.value = '';
        await prefs.clear();
        print('Signed out successfully');
        Get.offAllNamed(AppRoutes.loginRoute);
        Get.snackbar('Success!', response.body['message']);
      }
    } catch (e) {
      print(e);
    }
  }
}
