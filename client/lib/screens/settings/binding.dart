import 'package:get/get.dart';

import 'controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(
        apiRepository: Get.find(),
      ),
    );
  }
}
