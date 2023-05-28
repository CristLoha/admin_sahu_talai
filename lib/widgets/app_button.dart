import 'package:flutter/material.dart';
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
      width: 90,
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          textStyle: whiteTextStyle.copyWith(
            fontSize: 13,
            fontWeight: medium,
          ),
          backgroundColor: shamrockGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(
          text,
        ),
      ),
    );
  }
}
