import 'package:admin_sahu_talai/utils/extension/box_extension.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controller/audio_controller.dart';
import '../../infrastructure/theme/theme.dart';
import '../../widgets/text_underline.dart';
import '../../widgets/title_appbar.dart';
import '../home/controllers/home.controller.dart';
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
                height: c.selectedDirection.value == LanguageDirection.indSahu
                    ? 260
                    : 200,
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
                                    ? data['kataSahu'].toString()
                                    : data['kataIndonesia'].toString(),
                                textStyle: TextStyle(
                                  fontSize: 40,
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
                                    ? data['kataIndonesia'].toString()
                                    : data['kataSahu'].toString(),
                                textStyle: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400,
                                  color: white,
                                ),
                              ),
                            ),
                            c.selectedDirection.value ==
                                    LanguageDirection.indSahu
                                ? 30.heightBox
                                : 20.heightBox,
                            Visibility(
                              visible: c.selectedDirection.value ==
                                  LanguageDirection
                                      .indSahu, // jika isSahu false, tampilkan
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          onTap: () async {
                                            await _audioController
                                                .togglePlaying(
                                                    data['audioUrlPria']);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 18),
                                              child: Column(
                                                children: [
                                                  const Icon(
                                                    EvaIcons.volumeUp,
                                                    color: white,
                                                  ),
                                                  Text(
                                                    'Pria',
                                                    style: whiteTextStyle
                                                        .copyWith(fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  30.widthBox,
                                  Column(
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          onTap: () async {
                                            await _audioController
                                                .togglePlaying(
                                                    data['audioUrlWanita']);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
                                              child: Column(
                                                children: [
                                                  const Icon(
                                                    EvaIcons.volumeUp,
                                                    color: white,
                                                  ),
                                                  Text(
                                                    'Wanita',
                                                    style: whiteTextStyle
                                                        .copyWith(fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: darkBlue,
                      ),
                    ),
                    UnderlineText(
                      text:
                          c.selectedDirection.value == LanguageDirection.indSahu
                              ? data['contohKataSahu'].toString()
                              : data['contohKataIndo'].toString(),
                      textStyle: TextStyle(
                        fontSize: 28,
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
