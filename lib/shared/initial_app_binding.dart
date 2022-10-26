import 'package:get/get.dart';
import 'package:wowme/controllers/auth_controller.dart';
import 'package:wowme/controllers/calls_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(CallsController(), permanent: true);
  }
}
