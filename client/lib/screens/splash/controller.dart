import 'package:playback/routes/routes.dart';
import 'package:playback/shared/shared.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  void onReady() async {
    super.onReady();

    await Future.delayed(
      const Duration(milliseconds: 2000),
    );

    var storage = Get.find<SharedPreferences>();
    try {
      if (storage.getString(StorageConstants.token) != null) {
        Get.toNamed(
          Routes.home,
        );
      } else {
        Get.toNamed(
          Routes.auth,
        );
      }
    } catch (e) {
      print(e);
      Get.toNamed(
        Routes.auth,
      );
    }
  }
}