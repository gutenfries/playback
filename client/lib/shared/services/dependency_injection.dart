import 'package:get/get.dart';

import 'package:playback/shared/services/services.dart';

class DenpendencyInjection {
  static Future<void> init() async {
    await Get.putAsync(() => StorageService().init());
  }
}
