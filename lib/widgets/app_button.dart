import 'package:flutter/material.dart';
import '../infrastructure/theme/theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Function()? onPressed;

  const AppButton({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
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
