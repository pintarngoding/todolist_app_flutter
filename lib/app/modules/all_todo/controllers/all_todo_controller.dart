import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AllTodoController extends GetxController {
  //TODO: Implement AllTodoController

  final count = 0.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController searchC = TextEditingController();

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
  }

  void increment() => count.value++;

  Future<QuerySnapshot<Map<String, dynamic>>> getAllResult() async {
    String uid = auth.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> query;
    if (searchC.text != "") {
      query = await firestore
          .collection("users")
          .doc(uid)
          .collection("todos")
          // .startAt([searchC.text]).endAt([searchC.text + '\uf8ff'])
          .where("title", isGreaterThanOrEqualTo: searchC.text)
          .where("title", isLessThan: "${searchC.text}z")
          // .orderBy(
          //   "created_at",
          //   descending: true,
          // )
          .get();
    } else {
      query = await firestore
          .collection("users")
          .doc(uid)
          .collection("todos")
          .orderBy(
            "created_at",
            descending: true,
          )
          .get();
    }
    return query;
  }
}
