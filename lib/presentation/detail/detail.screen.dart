import 'package:admin_sahu_talai/utils/extension/box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../app/controller/audio_controller.dart';
import '../../infrastructure/theme/theme.dart';
import '../../widgets/text_underline.dart';
import '../../widgets/title_appbar.dart';
import '../home/controllers/home.controller.dart';
import '../../widgets/audio_button.dart';
import 'controllers/detail.controller.dart';

class DetailScreen extends GetView<DetailController> {
  final dynamic data = Get.arguments;
  final HomeController c = Get.find<HomeController>();
  final AudioController _audioController = Get.put(AudioController());

  DetailScreen({Key? key}) : super(key: key);

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
                height: c.selectedDirection.value == LanguageDirection.sahuInd
                    ? 260.h
                    : 200.h,
                color: shamrockGreen,
                child: SafeArea(
                  child: Obx(
                    () => Column(
                      children: [
                        60.heightBox,
                        Column(
                          children: [
                            Center(
                              child: UnderlineText(
                                text: c.selectedDirection.value ==
                                        LanguageDirection.indSahu
                                    ? data['kataIndonesia'].toString()
                                    : data['kataSahu'].toString(),
                                textStyle: TextStyle(
                                  fontSize:
                                      data['kataIndonesia'].toString().length >
                                              10
                                          ? 14.0
                                          : 30.0,
                                  fontWeight: FontWeight.w500,
                                  color: white,
                                ),
                              ),
                            ),
                            8.heightBox,
                            Center(
                              child: UnderlineText(
                                text: c.selectedDirection.value ==
                                        LanguageDirection.indSahu
                                    ? data['kataSahu'].toString()
                                    : data['kataIndonesia'].toString(),
                                textStyle: TextStyle(
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.w400,
                                  color: white,
                                ),
                              ),
                            ),
                            c.selectedDirection.value ==
                                    LanguageDirection.sahuInd
                                ? 30.heightBox
                                : 20.heightBox,
                            Visibility(
                              visible: c.selectedDirection.value ==
                                  LanguageDirection.sahuInd,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  /// INI TOMBOL UNTUK SPEAKER/AUDIO
                                  AudioButton(
                                    isPlaying: _audioController.isPlayingPria,
                                    onTap: () async {
                                      if (data['audioUrlPria'] != null) {
                                        await _audioController
                                            .togglePlayingPria(
                                                data['audioUrlPria']);
                                      } else {
                                        _audioController.infoFailed(
                                            "File audio belum tersedia",
                                            "Mohon maaf, file audio belum tersedia");
                                      }
                                    },
                                    label: 'Pria',
                                  ),
                                  20.widthBox,
                                  AudioButton(
                                    isPlaying: _audioController.isPlayingWanita,
                                    onTap: () async {
                                      if (data['audioUrlWanita'] != null) {
                                        await _audioController
                                            .togglePlayingWanita(
                                                data['audioUrlWanita']);
                                      } else {
                                        _audioController.infoFailed(
                                            "File audio belum tersedia",
                                            "Mohon maaf, file audio belum tersedia");
                                      }
                                    },
                                    label: 'Wanita',
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contoh Kalimat: ',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500,
                        color: darkBlue,
                      ),
                    ),
                    UnderlineText(
                      text:
                          c.selectedDirection.value == LanguageDirection.indSahu
                              ? data['contohKataIndo'].toString()
                              : data['contohKataSahu'].toString(),
                      textStyle: TextStyle(
                        fontSize: 28.sp,
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
