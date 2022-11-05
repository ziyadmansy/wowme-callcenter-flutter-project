import 'dart:async';

import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony/telephony.dart';
import 'package:wakelock/wakelock.dart';
import 'package:wowme/controllers/calls_controller.dart';
import 'package:wowme/pages/call_logs_page.dart';
import 'package:wowme/pages/menu_page.dart';
import 'package:wowme/shared/shared_core.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final callsController = Get.find<CallsController>();

  int _selectedBottomNav = 0;
  List<Map<String, Object>> _bottomNavItems = [];

  Timer? callLogCheckerTimer;

  @override
  void initState() {
    super.initState();
    _bottomNavItems = [
      {
        'title': 'Call Logs',
        'body': const CallLogsPage(),
      },
      {
        'title': 'Menu',
        'body': const MenuPage(),
      },
    ];

    // Check new call logs
    callLogCheckerTimer = Timer.periodic(
      const Duration(seconds: 15),
      (timer) async {
        try {
          Wakelock.enable();
        } catch (e) {
          print(e);
        }
        final currentCallState = await callsController.checkCallState();
        if (currentCallState == CallState.RINGING ||
            currentCallState == CallState.OFFHOOK) {
          // In case the phone is ringing(CallState.RINGING)
          // Or case the phone is in call(CallState.OFFHOOK)
          callsController.noOfLogsMsg.value =
              '${callsController.noOfLogsMsg.value}\n${currentCallState.name}';
          return;
        } else {
          await submitCallLogs();
        }
      },
    );
  }

  Future<void> submitCallLogs() async {
    Iterable<CallLogEntry> entries = await CallLog.get();

    await callsController.submitCallLogs(entries.toList());
  }

  @override
  void dispose() {
    super.dispose();
    callLogCheckerTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: SharedCore.buildAppBar(
            title: _bottomNavItems[_selectedBottomNav]['title'] as String,
            actions: [
              callsController.isLoading.value
                  ? SharedCore.buildLoaderIndicator()
                  : IconButton(
                      onPressed: submitCallLogs,
                      icon: const Icon(
                        Icons.refresh,
                      ),
                      tooltip: 'Refresh Logs',
                    ),
            ]),
        bottomNavigationBar: BottomAppBar(
          child: BottomNavigationBar(
            elevation: 0,
            currentIndex: _selectedBottomNav,
            onTap: (selectedItem) {
              setState(() {
                _selectedBottomNav = selectedItem;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.call,
                ),
                label: _bottomNavItems[0]['title'] as String?,
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.menu,
                ),
                label: _bottomNavItems[1]['title'] as String?,
              )
            ],
          ),
        ),
        body: _bottomNavItems[_selectedBottomNav]['body'] as Widget?,
      );
    });
  }
}
