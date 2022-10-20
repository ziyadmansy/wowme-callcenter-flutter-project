import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowme/controllers/calls_controller.dart';
import 'package:wowme/pages/call_logs_page.dart';
import 'package:wowme/pages/settings_page.dart';
import 'package:wowme/shared/shared_core.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedBottomNav = 0;
  List<Map<String, Object>> _bottomNavItems = [];

  @override
  void initState() {
    super.initState();
    _bottomNavItems = [
      {
        'title': 'Call Logs',
        'body': const CallLogsPage(),
      },
      {
        'title': 'Settings',
        'body': const SettingsPage(),
      },
    ];

    submitCallLogs();
  }

  Future<void> submitCallLogs() async {
    Iterable<CallLogEntry> entries = await CallLog.get();

    final callsController = Get.find<CallsController>();
    await callsController.submitCallLogs(entries.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedCore.buildAppBar(
        title: _bottomNavItems[_selectedBottomNav]['title'] as String,
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 6,
        shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(5),
            ),
          ),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(22),
            ),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          // CRITICAL ↓ a solid color here destroys FAB notch. Use alpha 0!
          backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
          currentIndex: _selectedBottomNav,
          onTap: (selectedItem) {
            setState(() {
              _selectedBottomNav = selectedItem;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.home,
              ),
              label: _bottomNavItems[0]['title'] as String?,
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.settings,
              ),
              label: _bottomNavItems[1]['title'] as String?,
            )
          ],
        ),
      ),
      body: _bottomNavItems[_selectedBottomNav]['body'] as Widget?,
    );
  }
}
