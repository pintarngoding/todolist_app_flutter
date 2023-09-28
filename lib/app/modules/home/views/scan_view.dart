import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';

class ScanView extends StatelessWidget {
  const ScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRCodeDartScanView(
        scanInvertedQRCode:
            false, // enable scan invert qr code ( default = false)
        typeScan: TypeScan
            .live, // if TypeScan.takePicture will try decode when click to take a picture (default TypeScan.live)
        takePictureButtonBuilder: (context, controller, isLoading) {
          // if typeScan == TypeScan.takePicture you can customize the button.
          if (isLoading) return CircularProgressIndicator();
          return ElevatedButton(
            onPressed: controller.takePictureAndDecode,
            child: Text('Take a picture'),
          );
        },
        resolutionPreset: QRCodeDartScanResolutionPreset.high,
        formats: [
          // You can restrict specific formats.
          BarcodeFormat.QR_CODE,
          BarcodeFormat.AZTEC,
          BarcodeFormat.DATA_MATRIX,
          BarcodeFormat.PDF_417,
          BarcodeFormat.CODE_39,
          BarcodeFormat.CODE_93,
          BarcodeFormat.CODE_128,
          BarcodeFormat.EAN_8,
          BarcodeFormat.EAN_13,
        ],
        onCapture: (Result result) {
          Get.offNamed(Routes.RESULT_SCAN, arguments: {'result': result.text});
          // print(result.text);
          // do anything with result
          // result.text
          // result.rawBytes
          // result.resultPoints
          // result.format
          // result.numBits
          // result.resultMetadata
          // result.time
        },
      ),
    );
  }
}
