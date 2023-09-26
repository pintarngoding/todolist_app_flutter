import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_crud_firebase/app/modules/add_todo/views/camera_view.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../widgets/custom_toast.dart';

class AddTodoController extends GetxController {
  //TODO: Implement AddTodoController

  final count = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingCreateTodo = false.obs;

  TextEditingController titleC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  File? file;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();

    titleC.dispose();
    descriptionC.dispose();
  }

  void increment() => count.value++;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path ?? '');
    } else {
      // User canceled the picker
    }
    update();
  }

  void toCamera() {
    Get.to(CameraView())!.then((result) {
      file = result;
      update();
    });
  }

  Future<void> addTodo() async {
    if (titleC.text.isNotEmpty && descriptionC.text.isNotEmpty) {
      isLoading.value = true;

      if (isLoadingCreateTodo.isFalse) {
        await createTodoData();
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      CustomToast.errorToast('Error', 'you need to fill all form');
    }
  }

  createTodoData() async {
    isLoadingCreateTodo.value = true;
    String adminEmail = auth.currentUser!.email!;
    if (file != null) {
      try {
        String uid = auth.currentUser!.uid;
        CollectionReference<Map<String, dynamic>> childrenCollection =
            await firestore.collection("users").doc(uid).collection("todos");

        var uuidTodo = Uuid().v1();

        String fileName = file!.path.split('/').last;
        String ext = fileName.split(".").last;
        String upDir = "image/${uuidTodo}.$ext";

        var snapshot =
            await firebaseStorage.ref().child('images/$upDir').putFile(file!);
        var downloadUrl = await snapshot.ref.getDownloadURL();

        await childrenCollection.doc(uuidTodo).set({
          "task_id": uuidTodo,
          "title": titleC.text,
          "description": descriptionC.text,
          "image": downloadUrl,
          "created_at": DateTime.now().toIso8601String(),
        });

        Get.back(); //close dialog
        Get.back(); //close form screen
        CustomToast.successToast('Success', 'Berhasil menambahkan todo');

        isLoadingCreateTodo.value = false;
      } on FirebaseAuthException catch (e) {
        isLoadingCreateTodo.value = false;
        CustomToast.errorToast('Error', 'error : ${e.code}');
      } catch (e) {
        isLoadingCreateTodo.value = false;
        CustomToast.errorToast('Error', 'error : ${e.toString()}');
      }
    } else {
      CustomToast.errorToast('Error', 'gambar tidak boleh kosong !!');
    }
  }
}
