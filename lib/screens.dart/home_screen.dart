import 'package:flutter/material.dart';
import 'package:wowme/pages/call_logs_page.dart';
import 'package:wowme/pages/menu_page.dart';
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
        'title': 'Menu',
        'body': const MenuPage(),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedCore.buildAppBar(
        title: _bottomNavItems[_selectedBottomNav]['title'] as String,
      ),
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
  }
}
