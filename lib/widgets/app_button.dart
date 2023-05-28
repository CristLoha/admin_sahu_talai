import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../infrastructure/theme/theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      width: 283.w,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          textStyle: whiteTextStyle.copyWith(
            fontSize: 13,
            fontWeight: medium,
          ),
          backgroundColor: shamrockGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(56),
          ),
        ),
        child: Text(
          text,
        ),
      ),
    );
  }
}
