import 'package:flutter/material.dart';

import '../infrastructure/theme/theme.dart';

class TittleAppBar extends StatelessWidget {
  final String title;
  const TittleAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: whiteTextStyle.copyWith(
        fontSize: 20,
        fontWeight: semiBold,
      ),
    );
  }
}
