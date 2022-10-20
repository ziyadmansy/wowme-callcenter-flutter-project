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
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => callsController.isLoading.value
          ? Center(
              child: SharedCore.buildLoaderIndicator(),
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check,
                    color: greenColor,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'All Call Logs are up to date!',
                    style: TextStyle(
                      color: greenColor,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}