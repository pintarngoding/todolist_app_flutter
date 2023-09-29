import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:printing/printing.dart';

class CetakController extends GetxController {
  //TODO: Implement CetakController

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List items = [];

  Future<void> getData() async {
    String uid = auth.currentUser!.uid;
    print(uid);
    QuerySnapshot<Map<String, dynamic>> result =
        await firestore.collection("users").doc(uid).collection("todos").get();

    result.docs.forEach((e) {
      items.add(e);
      print(e);
    });
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    getData();
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

  void cetakPdf() async {
    final doc = pw.Document();
    print(items);
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Table(
              children: [
            pw.TableRow(children: [
              pw.Text("No"),
              pw.Text("Nama"),
              pw.Text("Qrcode"),
            ]),
          ]..addAll(items.map((e) {
                  return pw.TableRow(
                    children: [
                      pw.Text("1"),
                      pw.Text(e["title"]),
                      pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: "Aa",
                        color: PdfColors.black,
                        width: 50,
                        height: 50,
                      ),
                    ],
                  );
                })));
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}
