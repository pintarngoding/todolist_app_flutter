import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/modules/add_todo/views/camera_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:uuid/uuid.dart';

import '../../../widgets/custom_toast.dart';

class AddTodoController extends GetxController {
  //TODO: Implement AddTodoController

  final count = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingCreateTodo = false.obs;

  TextEditingController titleC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();
  TextEditingController timeC = TextEditingController();
  TextEditingController addtimeC = TextEditingController();
  TextEditingController lasttimeC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  File? file;

  Position? currentPosition;
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void getCurrentLocation() async {
    try {
      currentPosition = await determinePosition();
      update();
    } catch (e) {
      Get.defaultDialog(
        title: "",
        contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        radius: 8,
        titlePadding: EdgeInsets.zero,
        titleStyle: TextStyle(fontSize: 0),
        content: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Error",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    e.toString(),
                    style: TextStyle(
                      color: Colors.grey,
                      height: 150 / 100,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        "batal",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 6,
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        await Geolocator.openAppSettings();
                      },
                      child: Text("Request Permission"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
      log(e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();

    getCurrentLocation();
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

  void cropFile() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    file = File(croppedFile!.path);
    update();
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path ?? '');
      cropFile();
    } else {
      // User canceled the picker
    }
  }

  void toCamera() {
    Get.to(CameraView())!.then((result) {
      file = result;
      cropFile();
      // update();
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
