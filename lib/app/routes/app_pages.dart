import 'package:get/get.dart';

import '../modules/add_todo/bindings/add_todo_binding.dart';
import '../modules/add_todo/views/add_todo_view.dart';
import '../modules/all_todo/bindings/all_todo_binding.dart';
import '../modules/all_todo/views/all_todo_view.dart';
import '../modules/detail_todo/bindings/detail_todo_binding.dart';
import '../modules/detail_todo/views/detail_todo_view.dart';
import '../modules/edit_todo/bindings/edit_todo_binding.dart';
import '../modules/edit_todo/views/edit_todo_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.ADD_TODO,
      page: () => const AddTodoView(),
      binding: AddTodoBinding(),
    ),
    GetPage(
      name: _Paths.ALL_TODO,
      page: () => const AllTodoView(),
      binding: AllTodoBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_TODO,
      page: () => const DetailTodoView(),
      binding: DetailTodoBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_TODO,
      page: () => const EditTodoView(),
      binding: EditTodoBinding(),
    ),
  ];
}
