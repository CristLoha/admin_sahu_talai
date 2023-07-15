import 'package:admin_sahu_talai/utils/extension/box_extension.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../infrastructure/theme/theme.dart';
import 'components/form_upload.dart';
import 'controllers/add_words.controller.dart';

class AddWordsScreen extends GetView<AddWordsController> {
  const AddWordsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      appBar: AppBar(
          backgroundColor: shamrockGreen,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: white),
          title: const Text('Tambah Kata')),
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
                            borderRadius: BorderRadius.all(
                              Radius.circular(13),
                            ),
                            color: white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 22),
                            child: FormUploadAdd(),
                          ),
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
