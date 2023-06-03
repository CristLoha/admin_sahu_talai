import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../widgets/text_underline.dart';
import '../home/controllers/home.controller.dart';
import 'controllers/detail.controller.dart';

class DetailScreen extends GetView<DetailController> {
  final dynamic data = Get.arguments;

  final HomeController c = Get.find<HomeController>();
  DetailScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailScreen'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: UnderlineText(
              text: data[c.selectedDirection.value == LanguageDirection.indSahu
                  ? 'kataIndonesia'
                  : 'kataSahu'],
            ),
          ),
          UnderlineText(
            text: data[c.selectedDirection.value == LanguageDirection.indSahu
                ? 'contohKataIndo'
                : 'contohKataSahu'],
          ),
        ],
      ),
    );
  }
}
