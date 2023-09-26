import 'package:get/get.dart';

import '../controllers/edit_todo_controller.dart';

class EditTodoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditTodoController>(
      () => EditTodoController(),
    );
  }
}
