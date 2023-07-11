import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/extension/lottie_string.dart';

class SplashLoading extends StatelessWidget {
  const SplashLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SizedBox(
          width: Get.width * 0.5,
          height: Get.width * 0.5,
          child: Lottie.asset(LottieString.loading),
        ),
      ),
    );
  }
}
