import 'dart:convert';
import 'package:call_log/call_log.dart';
import 'package:get/get.dart';
import 'package:telephony/telephony.dart';
import 'package:wowme/controllers/auth_controller.dart';
import 'package:wowme/shared/api_routes.dart';
import 'package:wowme/shared/shared_core.dart';

class CallsController extends GetConnect {
  Rx<bool> isLoading = false.obs;

  Future<CallState> checkCallState() async {
    final Telephony telephony = Telephony.instance;
    CallState state = await telephony.callState;
    print(state.name);
    return state;
  }

  Future<void> submitCallLogs(List<CallLogEntry> logs) async {
    try {
      if (logs.isEmpty) {
        return;
      }

      isLoading.value = true;

      final lastCallLog = await getLastCallLog();

      List<CallLogEntry> newLogs = logs;

      if (lastCallLog != null) {
        // Filters only new logs if last call log is available
         newLogs = logs
            .where((log) => log.timestamp != null)
            .where((log) => DateTime.fromMicrosecondsSinceEpoch(log.timestamp!)
                .isAfter(lastCallLog))
            .toList();
      }

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
        // Get.snackbar('Up to date!', 'You are already up to date');
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
          'Call logs submitted successfully!',
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

  Future<DateTime?> getLastCallLog() async {
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
        if (response.body['last_call_log'] != null) {
          final lastCallDateTime = DateTime.fromMicrosecondsSinceEpoch(
            int.parse(response.body['last_call_log']['timestamp']),
          );
          return lastCallDateTime;
        } else {
          return null;
        }
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
