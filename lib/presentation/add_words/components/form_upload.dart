import 'package:admin_sahu_talai/presentation/add_words/controllers/add_words.controller.dart';
import 'package:admin_sahu_talai/utils/extension/box_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_dropdown.dart';
import '../../../widgets/app_input.dart';
import '../../../widgets/title_input.dart';
import 'audio_pria_upload.dart';
import 'audio_wanita_upload.dart';

final _formKey = GlobalKey<FormState>();

class FormUploadAdd extends StatelessWidget {
  final AddWordsController controller = Get.put(AddWordsController());

  FormUploadAdd({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              AppDropDown(),
              5.heightBox,
              Obx(() => Text(
                    controller.errorText
                        .value, // Menampilkan pesan kesalahan jika ada
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
            text: 'Kirim',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (controller.selectedOption.isEmpty) {
                  // Tampilkan pesan error jika dropdown belum dipilih
                  controller.errorText.value = 'Pilih salah satu opsi';
                } else {
                  // Kirim data ke Firebase jika dropdown sudah dipilih
                  controller.sendDataToFirebase();
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
