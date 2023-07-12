import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../infrastructure/navigation/routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // Jika tidak ada pengguna yang masuk, maka arahkan ke layar Home Pengguna
        Future.delayed(const Duration(seconds: 7), () {
          Get.offAllNamed(Routes.home);
        });
      } else {
        // Jika sudah ada pengguna yang masuk, maka arahkan ke layar Home Admin
        Get.offAllNamed(Routes.admin);
      }
    });
  }
}
