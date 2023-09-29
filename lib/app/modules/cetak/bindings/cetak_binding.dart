import 'package:get/get.dart';

import '../controllers/cetak_controller.dart';

class CetakBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CetakController>(
      () => CetakController(),
    );
  }
}
