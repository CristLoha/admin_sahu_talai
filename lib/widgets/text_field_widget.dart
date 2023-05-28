import 'package:flutter/material.dart';

import '../infrastructure/theme/theme.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  const TextFieldWidget({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      cursorColor: darkBlue,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 10, bottom: 20),
        hintStyle: slateGreyTextStyle,
        hintText: 'Cari kata',
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: slateGrey),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            5,
          ),
          borderSide: const BorderSide(
            color: slateGrey,
          ),
        ),
      ),
    );
  }
}
