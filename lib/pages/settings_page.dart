import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowme/controllers/auth_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Logout'),
          leading: Icon(Icons.logout),
          onTap: () async {
            final authController = Get.find<AuthController>();

            await authController.logoutUser();
          },
        ),
      ],
    );
  }
}
