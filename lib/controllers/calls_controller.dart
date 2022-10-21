import 'dart:convert';
import 'package:call_log/call_log.dart';
import 'package:get/get.dart';
import 'package:wowme/controllers/auth_controller.dart';
import 'package:wowme/shared/api_routes.dart';
import 'package:wowme/shared/shared_core.dart';

class CallsController extends GetConnect {
  Rx<bool> isLoading = false.obs;

  Rx<bool> isCheckIn = true.obs;

  Future<void> submitCallLogs(List<CallLogEntry> logs) async {
    try {
      // Flip button action
      isCheckIn.value = !isCheckIn.value;

      if (logs.isEmpty) {
        Get.snackbar('Empty Logs', 'No data to send');
        return;
      }

      isLoading.value = true;

      final lastCallLog = await getLastCallLog();

      // Filters only new logs
      final newLogs = logs
          .where((log) => log.timestamp != null)
          .where((log) => DateTime.fromMicrosecondsSinceEpoch(log.timestamp!)
              .isAfter(lastCallLog))
          .toList();

      const url = ApiRoutes.callLogs;
      print(url);

      // Maps the filtered logs to a json map
      final formattedLogs = newLogs
          .map((log) => {
                'name': log.name,
                'number': log.number,
                'formatted_number': log.formattedNumber,
                'call_type': SharedCore.getCallTypeStringValue(log.callType),
                'duration': log.duration,
                'timestamp': log.timestamp.toString(),
                'cached_number_type': log.cachedNumberType,
                'cached_number_label': log.cachedNumberLabel,
                'sim_display_name': log.simDisplayName,
                'phone_account_id': log.phoneAccountId,
              })
          .toList();

      print(formattedLogs);

      if (formattedLogs.isEmpty) {
        // No new Call Logs
        Get.snackbar('Up to date!', 'You are already up to date');
        return;
      }

      final Response response = await post(
        url,
        json.encode(formattedLogs),
        headers: {
          'Authorization': SharedCore.getAccessToken().value,
        },
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        // Success
        Get.snackbar(
          'Success - Code ${response.statusCode}',
          isCheckIn.value
              ? 'Checked in successfully'
              : 'Checked out successfully',
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

  Future<DateTime> getLastCallLog() async {
    try {
      const url = ApiRoutes.lastCallLogs;
      print(url);

      final Response response = await get(
        url,
        headers: {
          'Authorization': SharedCore.getAccessToken().value,
        },
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        // Success
        final lastCallDateTime = DateTime.fromMicrosecondsSinceEpoch(
          int.parse(response.body['last_call_log']['timestamp']),
        );
        return lastCallDateTime;
      } else if (response.statusCode == 422) {
        final authController = Get.find<AuthController>();

        await authController.logoutUser();
        throw Exception();
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
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
