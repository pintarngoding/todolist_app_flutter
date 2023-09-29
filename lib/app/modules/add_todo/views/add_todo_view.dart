import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../utils/app_color.dart';
import '../../../widgets/custom_input.dart';
import '../controllers/add_todo_controller.dart';

class AddTodoView extends GetView<AddTodoController> {
  const AddTodoView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Todo',
          style: TextStyle(
            color: AppColor.secondary,
            fontSize: 14,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset('assets/icons/arrow-left.svg'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: AppColor.secondaryExtraSoft,
          ),
        ),
      ),
      body: GetBuilder<AddTodoController>(builder: (controller) {
        return ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(20),
          children: [
            CustomInput(
              controller: controller.titleC,
              label: 'Nama Todo',
              hint: 'Menyelesaikan tugas',
            ),
            CustomInput(
              controller: controller.descriptionC,
              label: 'Deskripsi Todo',
              hint: 'Diselesaikan sebelum tanggal 25',
            ),
            CustomInput(
              controller: controller.timeC,
              label: 'Waktu Todo',
              hint: 'Waktu',
              isTime: true,
            ),
            (controller.currentPosition != null)
                ? SizedBox(
                    height: 300,
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(controller.currentPosition!.latitude,
                            controller.currentPosition!.longitude),
                        zoom: 13,
                      ),
                      nonRotatedChildren: [
                        RichAttributionWidget(
                          attributions: [
                            TextSourceAttribution(
                              'OpenStreetMap contributors',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(
                                  controller.currentPosition!.latitude,
                                  controller.currentPosition!.longitude),
                              width: 48,
                              height: 48,
                              builder: (context) => Image.network(
                                  "https://www.pngall.com/wp-content/uploads/2017/05/Map-Marker-PNG-Pic.png"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            const SizedBox(
              height: 16,
            ),
            (controller.file != null)
                ? Image.file(controller.file!)
                : const SizedBox(),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.toCamera(),
                    child: Text(
                      'Kamera',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'poppins',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.primary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.pickFile(),
                    child: Text(
                      'Galeri',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'poppins',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.primary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Obx(
                () => ElevatedButton(
                  onPressed: () {
                    if (controller.isLoading.isFalse) {
                      controller.addTodo();
                    }
                  },
                  child: Text(
                    (controller.isLoading.isFalse)
                        ? 'Tambah todo'
                        : 'Loading...',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'poppins',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColor.primary,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
