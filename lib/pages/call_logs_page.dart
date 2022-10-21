import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowme/controllers/calls_controller.dart';
import 'package:wowme/shared/constants.dart';
import 'package:wowme/shared/shared_core.dart';

class CallLogsPage extends StatefulWidget {
  const CallLogsPage({super.key});

  @override
  State<CallLogsPage> createState() => _CallLogsPageState();
}

class _CallLogsPageState extends State<CallLogsPage> {
  final callsController = Get.find<CallsController>();

  @override
  void initState() {
    super.initState();
    submitCallLogs();
  }

  Future<void> submitCallLogs() async {
    Iterable<CallLogEntry> entries = await CallLog.get();

    final callsController = Get.find<CallsController>();

    await callsController.submitCallLogs(entries.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Image.asset(
                  appLogoPath,
                  width: MediaQuery.of(context).size.width / 1.5,
                  fit: BoxFit.fill,
                ),
              ),
              const Spacer(),
              callsController.isLoading.value
                  ? Center(
                      child: SharedCore.buildLoaderIndicator(),
                    )
                  : SizedBox(
                      width: Get.width,
                      child: SharedCore.buildRoundedElevatedButton(
                        btnChild: const Text(
                          'Start',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPress: submitCallLogs,
                      ),
                    ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
