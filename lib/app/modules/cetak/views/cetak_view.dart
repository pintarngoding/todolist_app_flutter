import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/cetak_controller.dart';

class CetakView extends GetView<CetakController> {
  const CetakView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CetakView'),
        centerTitle: true,
      ),
      body: GetBuilder<CetakController>(builder: (controller) {
        return Center(
            child: ElevatedButton(
                onPressed: () => controller.cetakPdf(), child: Text("Cetak")));
      }),
    );
  }
}
