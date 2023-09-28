import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/result_scan_controller.dart';

class ResultScanView extends GetView<ResultScanController> {
  const ResultScanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ResultScanView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          Get.arguments['result'],
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
