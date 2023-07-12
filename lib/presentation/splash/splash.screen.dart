import 'package:admin_sahu_talai/utils/extension/box_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'components/footer_splash.dart';
import 'components/loading_splash.dart';
import 'components/splash_logo.dart';
import 'controllers/splash.controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<SplashController>(
      init: SplashController(),
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            260.heightBox,
            const SplashLogo(),
            const SplashLoading(),
            const FooterSplash(),
          ],
        );
      },
    ));
  }
}
