import 'package:admin_sahu_talai/utils/extension/box_extension.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../app/controller/audio_controller.dart';
import '../../infrastructure/theme/theme.dart';
import '../../widgets/audio_button.dart';
import '../../widgets/text_underline.dart';
import '../../widgets/title_appbar.dart';
import '../home/controllers/home.controller.dart';
import 'controllers/admin_detail.controller.dart';

class AdminDetailScreen extends GetView<AdminDetailController> {
  final dynamic data = Get.arguments;
  final HomeController c = Get.put(HomeController());
  final AudioController _audioController = Get.put(AudioController());

  AdminDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: shamrockGreen,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: white),
        title: const TittleAppBar(title: 'Detail'),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 260,
                color: shamrockGreen,
                child: SafeArea(
                  child: Column(
                    children: [
                      60.heightBox,
                      Column(
                        children: [
                          Center(
                            child: UnderlineText(
                              text: data['kataSahu'].toString(),
                              textStyle: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w500,
                                color: white,
                              ),
                            ),
                          ),
                          8.heightBox,
                          Center(
                            child: UnderlineText(
                              text: data['kataIndonesia'].toString(),
                              textStyle: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                                color: white,
                              ),
                            ),
                          ),
                          30.heightBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /// INI TOMBOL UNTUK SPEAKER/AUDIO
                              AudioButton(
                                isPlaying: _audioController.isPlayingPria,
                                onTap: () async {
                                  await _audioController
                                      .togglePlayingPria(data['audioUrlPria']);
                                },
                                label: 'Pria',
                              ),
                              20.widthBox,
                              AudioButton(
                                isPlaying: _audioController.isPlayingWanita,
                                onTap: () async {
                                  await _audioController.togglePlayingWanita(
                                      data['audioUrlWanita']);
                                },
                                label: 'Wanita',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Contoh Kalimat Sahu: ",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: darkBlue,
                      ),
                    ),
                    UnderlineText(
                      text: data['contohKataSahu'] ?? 'N/A',
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: darkBlue,
                      ),
                    ),
                    10.heightBox,
                    const Text(
                      "Contoh Kalimat Indonesia:",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: darkBlue,
                      ),
                    ),
                    UnderlineText(
                      text: data['contohKataIndo'] ?? 'N/A',
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: darkBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
