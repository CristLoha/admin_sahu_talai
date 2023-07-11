import 'package:admin_sahu_talai/infrastructure/navigation/routes.dart';
import 'package:admin_sahu_talai/infrastructure/theme/theme.dart';
import 'package:admin_sahu_talai/presentation/home/components/dropdown_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/app_button.dart';
import '../../widgets/text_field_widget.dart';
import '../../widgets/text_underline.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        title: const Text("Kamus Sahu Tala'i"),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.login);
            },
            child: const Text(
              "Admin",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => TextFieldWidget(
                      controller: controller.searchController,
                      suffixIcon: controller.isFieldEmpty.value
                          ? null
                          : IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                controller.searchController.clear();
                                controller.isFieldEmpty.value = true;
                                controller.searchResults.clear();
                                controller.filteredResults.clear();
                                controller.update();
                              },
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                AppButton(
                  width: 90,
                  height: 46,
                  text: 'CARI',
                  onPressed: controller.search,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Obx(() => RadioListTile<LanguageDirection>(
                        title: const Text('IND-SAHU'),
                        value: LanguageDirection.indSahu,
                        groupValue: controller.selectedDirection.value,
                        onChanged: (value) {
                          controller.setDirection(value!);
                        },
                      )),
                ),
                Expanded(
                  child: Obx(() => RadioListTile<LanguageDirection>(
                        title: const Text('SAHU-IND'),
                        value: LanguageDirection.sahuInd,
                        groupValue: controller.selectedDirection.value,
                        onChanged: (value) {
                          controller.setDirection(value!);
                        },
                      )),
                ),
              ],
            ),
            const SizedBox(height: 10),
            AppDropDownHome(),
            const SizedBox(height: 30),
            StreamBuilder<QuerySnapshot>(
              stream: controller.stream.value,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Terjadi Kesalahan');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: darkGreen,
                    ),
                  );
                }

                return Obx(() {
                  List<QueryDocumentSnapshot> displayData;

                  if (controller.searchResults.isNotEmpty) {
                    displayData = controller.searchResults;
                  } else {
                    if (controller.filteredResults.isEmpty ||
                        controller.filteredResults.last.get('kataIndonesia') ==
                            "Data tidak cocok") {
                      final List<QueryDocumentSnapshot> docs =
                          snapshot.data!.docs;
                      List<QueryDocumentSnapshot> sortedDocs = docs;

                      if (controller.selectedOption.value != 'Semua') {
                        sortedDocs = docs
                            .where((doc) =>
                                doc['kategori'] ==
                                controller.selectedOption.value)
                            .toList();
                      }

                      sortedDocs.sort((a, b) {
                        String aKata = a[controller.selectedDirection.value ==
                                LanguageDirection.indSahu
                            ? 'kataIndonesia'
                            : 'kataSahu'];
                        String bKata = b[controller.selectedDirection.value ==
                                LanguageDirection.indSahu
                            ? 'kataIndonesia'
                            : 'kataSahu'];
                        return aKata.compareTo(bKata);
                      });

                      displayData = sortedDocs;
                    } else {
                      displayData = controller.filteredResults;
                    }
                  }

                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayData.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = displayData[index];
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        return Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            onTap: () {
                              Get.toNamed(Routes.detail,
                                  arguments: document); // Here
                            },
                            title: UnderlineText(
                              text: data[controller.selectedDirection.value ==
                                      LanguageDirection.indSahu
                                  ? 'kataIndonesia'
                                  : 'kataSahu'],
                            ),
                            subtitle: UnderlineText(
                              text: data[controller.selectedDirection.value ==
                                      LanguageDirection.indSahu
                                  ? 'kataSahu'
                                  : 'kataIndonesia'],
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        );
                      });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
