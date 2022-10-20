import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowme/controllers/auth_controller.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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
