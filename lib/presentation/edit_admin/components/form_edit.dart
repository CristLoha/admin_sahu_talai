import 'package:admin_sahu_talai/presentation/edit_admin/components/audio_pria_edit.dart';
import 'package:admin_sahu_talai/presentation/edit_admin/components/audio_wanita_edit.dart';
import 'package:admin_sahu_talai/presentation/edit_admin/controllers/edit_admin.controller.dart';
import 'package:admin_sahu_talai/utils/extension/box_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input.dart';
import '../../../widgets/title_input.dart';
import 'dropdown_edit.dart';

final _formKey = GlobalKey<FormState>();

class FormEditKamus extends StatelessWidget {
  final EditAdminController controller = Get.put(EditAdminController());

  FormEditKamus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.getKamusId(Get.arguments.toString()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TittleInput(
                    text: 'Kata Sahu',
                  ),
                  8.heightBox,
                  AppInput(
                    controller: controller.kSahu,
                  ),
                  16.heightBox,
                  const TittleInput(
                    text: 'Contoh Sahu',
                  ),
                  8.heightBox,
                  AppInput(
                    controller: controller.cKSahu,
                  ),
                  16.heightBox,
                  const TittleInput(
                    text: 'Kata Indonesia',
                  ),
                  8.heightBox,
                  AppInput(
                    controller: controller.kIndo,
                  ),
                  16.heightBox,
                  const TittleInput(
                    text: 'Contoh  Indonesia',
                  ),
                  8.heightBox,
                  AppInput(
                    controller: controller.cKIndo,
                  ),
                  16.heightBox,
                  const TittleInput(
                    text: 'Kategori',
                  ),
                  8.heightBox,
                  AppDropDownEdit(),
                  5.heightBox,
                  Obx(() => Text(
                        controller.errorText.value,
                        style: const TextStyle(color: Colors.red),
                      )),
                  16.heightBox,
                  const TittleInput(
                    text: 'Unggah Suara Pria',
                  ),
                  8.heightBox,
                  AppWidgetAudioPria(),
                  16.heightBox,
                  const TittleInput(
                    text: 'Unggah Suara Wanita',
                  ),
                  8.heightBox,
                  AppWidgetAudioWanita(),
                ],
              ),
              30.heightBox,
              AppButton(
                width: 283,
                height: 56,
                text: 'SIMPAN',
                onPressed: () {
                  controller.sendDataToFirebase(Get.arguments.toString());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
