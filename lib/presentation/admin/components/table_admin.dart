import 'package:admin_sahu_talai/infrastructure/navigation/routes.dart';
import 'package:admin_sahu_talai/infrastructure/theme/theme.dart';
import 'package:admin_sahu_talai/utils/extension/box_extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_sahu_talai/presentation/admin/controllers/admin.controller.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/text_field_widget.dart';
import '../../../widgets/text_underline.dart';

class TableAdmin extends StatelessWidget {
  final AdminController adminController = Get.put(AdminController());

  TableAdmin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: adminController.getStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Memuat..'));
        }

        final documents = snapshot.data!.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFieldWidget(
                    controller: adminController.searchController,
                  ),
                ),
                12.widthBox,
                AppButton(
                    width: 90,
                    height: 46,
                    text: 'CARI',
                    onPressed: () {
                      adminController.search();
                    }),
              ],
            ),
            30.heightBox,
            Obx(() {
              List<QueryDocumentSnapshot> results;

              if (adminController.searchResults.isEmpty ||
                  adminController.searchResults.last == "Data tidak cocok") {
                results = documents;
              } else {
                results = documents.where((document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return adminController.searchResults
                          .contains(data['kataSahu']) ||
                      adminController.searchResults
                          .contains(data['kataIndonesia']);
                }).toList();
              }

              return Text(
                "Total kata: ${results.length}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              );
            }),
            20.heightBox,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() {
                List<QueryDocumentSnapshot> results;

                if (adminController.searchResults.isEmpty ||
                    adminController.searchResults.last == "Data tidak cocok") {
                  results = documents;
                } else {
                  results = documents.where((document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return adminController.searchResults
                            .contains(data['kataSahu']) ||
                        adminController.searchResults
                            .contains(data['kataIndonesia']);
                  }).toList();
                }

                return DataTable(
                    headingRowColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(40);
                        }
                        return darkGray;
                      },
                    ),
                    columnSpacing: 10,
                    columns: const <DataColumn>[
                      DataColumn(
                          label: Text('ID_KATA',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: white))),
                      DataColumn(
                          label: Text('KATEGORI_KATA',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: white))),
                      DataColumn(
                          label: Text('KATA_INDO',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: white))),
                      DataColumn(
                          label: Text('KATA_SAHU',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: white))),
                      DataColumn(
                          label: Text('DETAIL/UBAH/HAPUS',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: white))),
                    ],
                    rows: List<DataRow>.generate(results.length, (index) {
                      QueryDocumentSnapshot document = results[index];
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;

                      return DataRow(
                        cells: <DataCell>[
                          DataCell(Text(document.id.length >= 5
                              ? document.id.substring(0, 5)
                              : document.id)),
                          DataCell(Text(data['kategori'] ?? 'N/A')),
                          DataCell(Text(data['kataIndonesia'] ?? 'N/A')),
                          DataCell(
                            UnderlineText(
                              text: data['kataSahu'] ?? 'N/A',
                            ),
                          ),
                          DataCell(
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.info),
                                  onPressed: () {
                                    Get.toNamed(Routes.admindDetail,
                                        arguments: data);
                                    print(index);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Get.toNamed(Routes.editAdmin,
                                        arguments: document.id);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: red,
                                  ),
                                  onPressed: () =>
                                      adminController.deleteHewan(document.id),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }));
              }),
            ),
          ],
        );
      },
    );
  }
}
