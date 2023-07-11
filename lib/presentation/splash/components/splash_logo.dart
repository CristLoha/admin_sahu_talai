import 'package:flutter/material.dart';
import '../../../utils/extension/img_string.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Image(
        image: AssetImage(ImgString.logoSahu),
        width: 158,
      ),
    );
  }
}
