import 'package:flutter/material.dart';

import '../infrastructure/theme/theme.dart';

class TittleInput extends StatelessWidget {
  final String text;
  const TittleInput({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: darkBlueTextStyle.copyWith(fontWeight: medium),
    );
  }
}
