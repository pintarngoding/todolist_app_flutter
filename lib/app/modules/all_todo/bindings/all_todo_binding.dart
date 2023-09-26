import 'package:get/get.dart';

import '../controllers/all_todo_controller.dart';

class AllTodoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllTodoController>(
      () => AllTodoController(),
    );
  }
}
