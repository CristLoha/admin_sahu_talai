import 'package:admin_sahu_talai/presentation/home/controllers/home.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../infrastructure/theme/theme.dart';

class AppDropDownHome extends StatelessWidget {
  AppDropDownHome({Key? key}) : super(key: key);
  final HomeController c = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: whisper),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: const Text("Pilih Kategori"),
              value: c.selectedOption.value.isEmpty
                  ? null
                  : c.selectedOption.value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: darkBlue),
              underline: const SizedBox.shrink(),
              onChanged: (newValue) {
                c.updateCategory(newValue!);
              },
              items: c.options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }
}
