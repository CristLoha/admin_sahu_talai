import 'package:admin_sahu_talai/utils/extension/box_extension.dart';
import 'package:admin_sahu_talai/widgets/app_button.dart';
import 'package:flutter/material.dart';

import '../../../widgets/text_field_widget.dart';

class AdminHeading extends StatelessWidget {
  const AdminHeading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: TextFieldWidget(),
        ),
        12.widthBox,
        AppButton(text: 'Cari', onPressed: () {}),
      ],
    );
  }
}
