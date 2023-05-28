import 'package:admin_sahu_talai/infrastructure/theme/theme.dart';
import 'package:admin_sahu_talai/utils/extension/box_extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_sahu_talai/presentation/admin/controllers/admin.controller.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/text_field_widget.dart';

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
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Memuat..');
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
                    text: 'Cari',
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
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Make it bold
                  fontSize: 20, // Increase the font size
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
                      return darkGray; // Use any color of your choice here
                    },
                  ),
                  dataRowColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.08);
                      }
                      return Colors.white; // Use any color of your choice here
                    },
                  ),
                  columnSpacing: 10, // Add some column spacing
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
                  rows: results.map<DataRow>((document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(document.id.length >= 5
                            ? document.id.substring(0, 5)
                            : document.id)),
                        DataCell(Text(data['kategori'] ?? 'N/A')),
                        DataCell(Text(data['kataIndonesia'] ?? 'N/A')),
                        DataCell(Text(data['kataSahu'] ?? 'N/A')),
                        DataCell(
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.info),
                                onPressed: () {
                                  // Do something for details
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Do something for edit
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Do something for delete
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
