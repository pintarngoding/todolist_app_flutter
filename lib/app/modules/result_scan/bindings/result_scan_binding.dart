import 'package:get/get.dart';

import '../controllers/result_scan_controller.dart';

class ResultScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResultScanController>(
      () => ResultScanController(),
    );
  }
}
