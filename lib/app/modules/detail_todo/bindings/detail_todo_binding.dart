import 'package:get/get.dart';

import '../controllers/detail_todo_controller.dart';

class DetailTodoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailTodoController>(
      () => DetailTodoController(),
    );
  }
}
