import 'package:flutter/material.dart';

class UnderlineText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  const UnderlineText({
    Key? key,
    required this.text,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.replaceAllMapped(
        RegExp(r'_\w'),
        (m) => '${m.group(0)![1]}̲',
      ),
      style: textStyle,
    );
  }
}
