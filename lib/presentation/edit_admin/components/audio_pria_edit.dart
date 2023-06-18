import 'package:admin_sahu_talai/presentation/edit_admin/controllers/edit_admin.controller.dart';
import 'package:admin_sahu_talai/utils/extension/box_extension.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../infrastructure/theme/theme.dart';

class AppWidgetAudioPria extends StatelessWidget {
  final EditAdminController c = Get.put(EditAdminController());
  AppWidgetAudioPria({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                if (c.isSelectedPria.value) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Reset Audio Pria',
                            style: darkBlueTextStyle.copyWith(
                              fontSize: 20,
                              fontWeight: bold,
                            )),
                        content: Text(
                            'Anda yakin ingin mereset audio pria yang sudah dipilih?',
                            style: darkGrayTextStyle.copyWith(
                              fontSize: 13,
                            )),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Batal',
                                style: darkGrayTextStyle.copyWith(
                                    fontWeight: medium, fontSize: 13)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              c.resetAudioPria();
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: shamrockGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              minimumSize: const Size(100.0, 40.0),
                            ),
                            child: Text('Reset',
                                style: whiteTextStyle.copyWith(
                                    fontSize: 13, fontWeight: medium)),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  c.pickAudioPria();
                }
              },
              child: const Padding(
                  padding: EdgeInsets.all(8.0), child: Icon(EvaIcons.upload)),
            ),
          ),
          8.widthBox,
          Flexible(
            flex: 1,

            ///NAMA
            child: Obx(() => Text(
                  c.audioFileNamePria.value,
                  style: darkGrayTextStyle.copyWith(fontWeight: medium),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                )),
          ),
          if (c.isSelectedPria.value)
            IconButton(
              onPressed: () => c.resetAudioPria(),
              icon: const Icon(
                EvaIcons.trash,
                color: oldRose,
              ),
            )
        ],
      ),
    );
  }
}
