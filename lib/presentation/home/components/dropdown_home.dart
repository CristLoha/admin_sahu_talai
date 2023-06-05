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
          color: Colors.white, // Ubah warna latar belakang
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: whisper),
          boxShadow: [
            // Tambahkan bayangan
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: const Text("Pilih Kategori",
                  style: TextStyle(color: Colors.grey)), // Ubah gaya hint text
              value: c.selectedOption.value.isEmpty
                  ? null
                  : c.selectedOption.value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down,
                  color: darkBlue), // Ubah warna ikon
              iconSize: 24,
              elevation: 16,
              style:
                  const TextStyle(color: darkBlue), // Ubah gaya teks dropdown
              underline: const SizedBox.shrink(),
              onChanged: (newValue) {
                c.updateCategory(newValue!);
              },
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
