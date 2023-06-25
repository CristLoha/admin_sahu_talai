import 'package:admin_sahu_talai/presentation/edit_admin/components/form_edit.dart';
import 'package:admin_sahu_talai/utils/extension/box_extension.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../infrastructure/theme/theme.dart';
import 'controllers/edit_admin.controller.dart';

class EditAdminScreen extends GetView<EditAdminController> {
  const EditAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      appBar: AppBar(
          backgroundColor: shamrockGreen,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: white),
          title: const Text('Ubah Kata')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  height: 240,
                  color: shamrockGreen,
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 24, right: 24, top: 20),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(13)),
                            color: white,
                          ),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 22),
                              child: FormEditKamus()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            40.heightBox,
          ],
        ),
      ),
    );
  }
}
