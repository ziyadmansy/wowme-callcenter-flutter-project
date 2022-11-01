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
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipOval(
                child: Image.asset(
                  appLogoPath,
                  width: MediaQuery.of(context).size.width / 1.5,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              callsController.noOfLogsMsg.value,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
