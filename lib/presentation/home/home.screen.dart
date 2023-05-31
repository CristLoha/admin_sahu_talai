import 'package:admin_sahu_talai/infrastructure/navigation/routes.dart';
import 'package:admin_sahu_talai/presentation/home/components/dropdown_home.dart';
import 'package:admin_sahu_talai/utils/extension/box_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../infrastructure/theme/theme.dart';
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
        backgroundColor: shamrockGreen,
        title: const Text("Kamus Sahu Tala'i"),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.admin);
            },
            child: const Text(
              "Login",
              style: TextStyle(
                color: Colors.white, // Atur warna teks sesuai kebutuhan
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      controller: controller.searchController,
                    ),
                  ),
                  12.widthBox,
                  AppButton(
                    width: 90,
                    height: 46,
                    text: 'CARI',
                    onPressed: () {
                      controller.search();
                    },
                  ),
                ],
              ),
              10.heightBox,

              ///RADIO BUTTON
              Row(
                children: [
                  Expanded(
                    child: Obx(() => Row(
                          children: [
                            Radio<LanguageDirection>(
                              value: LanguageDirection.indSahu,
                              groupValue: controller.selectedDirection.value,
                              onChanged: (LanguageDirection? value) {
                                controller.setDirection(value!);
                              },
                            ),
                            Text(
                              'IND-SAHU',
                              style: darkBlueTextStyle.copyWith(
                                fontSize: 15,
                                fontWeight: semiBold,
                              ),
                            ),
                          ],
                        )),
                  ),
                  Expanded(
                    child: Obx(() => Row(
                          children: [
                            Radio<LanguageDirection>(
                              value: LanguageDirection.sahuInd,
                              groupValue: controller.selectedDirection.value,
                              onChanged: (LanguageDirection? value) {
                                controller.setDirection(value!);
                              },
                            ),
                            Text(
                              'SAHU-IND',
                              style: darkBlueTextStyle.copyWith(
                                fontSize: 15,
                                fontWeight: semiBold,
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
              10.heightBox,

              ///KATEGORI
              AppDropDownHome(),
              30.heightBox,
              StreamBuilder<QuerySnapshot>(
                stream: controller.stream.value,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return Obx(() {
                    if (controller.selectedOption.value == 'Semua') {
                      if (controller.searchResults.isEmpty ||
                          controller.searchResults.last == "Data tidak cocok") {
                        return ListView(
                          shrinkWrap: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                title: UnderlineText(
                                  text: data[
                                      controller.selectedDirection.value ==
                                              LanguageDirection.indSahu
                                          ? 'kataIndonesia'
                                          : 'kataSahu'],
                                ),
                                subtitle: UnderlineText(
                                    text: data[
                                        controller.selectedDirection.value ==
                                                LanguageDirection.indSahu
                                            ? 'kataSahu'
                                            : 'kataIndonesia']),
                                trailing: const Icon(Icons
                                    .arrow_forward_ios), // Tambahkan ikon di akhir
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.searchResults.length,
                            itemBuilder: (context, index) => Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                leading: const Icon(
                                    Icons.search), // Tambahkan ikon di awal

                                title: UnderlineText(
                                  text: controller.searchResults[index],
                                ),
                                trailing: const Icon(Icons
                                    .arrow_forward_ios), // Tambahkan ikon di akhir
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      if (controller.filteredResults.isEmpty ||
                          controller.filteredResults.last ==
                              "Data tidak cocok") {
                        return ListView(
                          shrinkWrap: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            if (data['kategori'] ==
                                    controller.selectedOption.value ||
                                controller.selectedOption.value == 'Semua') {
                              return Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  title: UnderlineText(
                                    text: data[
                                        controller.selectedDirection.value ==
                                                LanguageDirection.indSahu
                                            ? 'kataIndonesia'
                                            : 'kataSahu'],
                                  ),
                                  subtitle: UnderlineText(
                                      text: data[
                                          controller.selectedDirection.value ==
                                                  LanguageDirection.indSahu
                                              ? 'kataSahu'
                                              : 'kataIndonesia']),
                                  trailing: const Icon(Icons
                                      .arrow_forward_ios), // Tambahkan ikon di akhir
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          }).toList(),
                        );
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.filteredResults.length,
                            itemBuilder: (context, index) {
                              String result = controller.filteredResults[index];
                              return Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.search),
                                  title: UnderlineText(
                                    text: result,
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
