import 'dart:convert';

import 'package:call_log/call_log.dart';
import 'package:get/get.dart';
import 'package:wowme/controllers/auth_controller.dart';
import 'package:wowme/shared/api_routes.dart';
import 'package:wowme/shared/shared_core.dart';

class CallsController extends GetConnect {
  Rx<bool> isLoading = false.obs;

  Future<void> submitCallLogs(List<CallLogEntry> logs) async {
    try {
      if (logs.isEmpty) {
        Get.snackbar('Empty Logs', 'No new call logs to send');
        return;
      }

      isLoading.value = true;

      const url = ApiRoutes.callLogs;
      print(url);

      final formattedLogs = logs
          .map((log) => {
                'name': log.name,
                'number': log.number,
                'formatted_number': log.formattedNumber,
                'call_type': log.callType.toString(),
                'duration': log.duration,
                'timestamp': log.timestamp,
                'cached_number_type': log.cachedNumberType,
                'cached_number_label': log.cachedNumberLabel,
                'sim_display_name': log.simDisplayName,
                'phone_account_id': log.phoneAccountId,
              })
          .toList();

      print(formattedLogs);

      final Response response = await post(
        url,
        json.encode(formattedLogs),
        headers: {
          'Authorization': SharedCore.getAccessToken().value,
        },
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        // Success
        Get.snackbar(
          'Call Logs - Code ${response.statusCode}',
          formattedLogs.toString(),
          duration: const Duration(seconds: 8),
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (response.statusCode == 422) {
        final authController = Get.find<AuthController>();

        await authController.logoutUser();
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        e.toString(),
        duration: const Duration(seconds: 8),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
