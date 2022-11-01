import 'dart:convert';
import 'package:call_log/call_log.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:wowme/controllers/auth_controller.dart';
import 'package:wowme/shared/api_routes.dart';
import 'package:wowme/shared/constants.dart';
import 'package:wowme/shared/shared_core.dart';

class CallsController extends GetConnect {
  Rx<bool> isLoading = false.obs;

  Rx<String> noOfLogsMsg = ''.obs;

  Future<CallState> checkCallState() async {
    final Telephony telephony = Telephony.instance;
    CallState state = await telephony.callState;
    print(state.name);
    return state;
  }

  Future<void> submitCallLogs(List<CallLogEntry> logs,
      {bool isBackground = false}) async {
    try {
      if (!isBackground) {
        // To prevent snack bars duplication
        Get.closeAllSnackbars();
      }

      if (logs.isEmpty) {
        noOfLogsMsg.value = 'Empty Call Logs';
        return;
      }

      isLoading.value = true;

      final lastCallLog = await getLastCallLog(isBackground);

      List<CallLogEntry> newLogs = logs;

      if (lastCallLog != null) {
        // Filters only new logs if last call log is available
        // We have to multiply the timestamp input by 1000 because
        // DateTime.fromMillisecondsSinceEpoch expects milliseconds but we use seconds.
        newLogs = logs
            .where((log) => log.timestamp != null)
            .where((log) => SharedCore.getDateTimeFromTimeStamp(log.timestamp!)
                .isAfter(lastCallLog))
            .toList();
        noOfLogsMsg.value =
            'There are ${newLogs.length} new logs to send\n${SharedCore.dateTimeFormat.format(lastCallLog)}';
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

      SharedPreferences prefs = await SharedPreferences.getInstance();

      final Response response = await post(
        url,
        json.encode(formattedLogs),
        headers: {
          'Authorization': isBackground
              ? prefs.getString(accessTokenPrefsKey)!
              : SharedCore.getAccessToken().value,
        },
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        // Success
        if (!isBackground) {
          Get.snackbar(
            'Success - Code ${response.statusCode}',
            '${newLogs.length} Call logs submitted successfully!',
          );
        }
      } else if (response.statusCode == 422 && !isBackground) {
        final authController = Get.find<AuthController>();

        await authController.logoutUser();
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      if (!isBackground) {
        Get.snackbar(
          'Server Error - Retrying again',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<DateTime?> getLastCallLog(bool isBackground) async {
    try {
      const url = ApiRoutes.lastCallLogs;
      print(url);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      final Response response = await get(
        url,
        headers: {
          'Authorization': isBackground
              ? prefs.getString(accessTokenPrefsKey)!
              : SharedCore.getAccessToken().value,
        },
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        // Success
        if (response.body['last_call_log'] != null) {
          final lastCallDateTime = SharedCore.getDateTimeFromTimeStamp(
            int.parse(response.body['last_call_log']['timestamp']),
          );
          return lastCallDateTime;
        } else {
          return null;
        }
      } else if (response.statusCode == 422 && !isBackground) {
        final authController = Get.find<AuthController>();

        await authController.logoutUser();
        throw Exception();
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
