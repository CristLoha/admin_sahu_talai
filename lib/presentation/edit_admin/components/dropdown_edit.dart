import 'package:admin_sahu_talai/presentation/edit_admin/controllers/edit_admin.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../infrastructure/theme/theme.dart';

class AppDropDownEdit extends StatelessWidget {
  AppDropDownEdit({Key? key}) : super(key: key);
  final EditAdminController c = Get.put(EditAdminController());

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
              value: c.selectedOption.value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: darkBlue),
              underline: const SizedBox.shrink(),
              onChanged: c.onOptionChanged,
              items: c.options.asMap().entries.map((entry) {
                int index = entry.key;
                String value = entry.value;
                return DropdownMenuItem<String>(
                  value: value,
                  // Tampilkan indeks + 1 dan kategori untuk setiap item
                  child: Text("${index + 1}. $value"),
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }
}
