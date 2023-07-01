import 'package:admin_sahu_talai/presentation/add_words/controllers/add_words.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../infrastructure/theme/theme.dart';

class AppInput extends StatelessWidget {
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final String? initialValue;

  final AddWordsController c = Get.put(AddWordsController());

  AppInput({
    Key? key,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Harap diisi";
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      cursorColor: darkBlue,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.start,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 10, bottom: 20),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: whisper,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            14,
          ),
          borderSide: const BorderSide(
            color: shamrockGreen,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            14,
          ),
          borderSide: const BorderSide(
            color: oldRose,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            14,
          ),
          borderSide: const BorderSide(
            color: oldRose,
          ),
        ),
      ),
      // menggunakan initialValue jika controller null
      initialValue: controller == null ? initialValue : null,
    );
  }
}
