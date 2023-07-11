import 'package:admin_sahu_talai/infrastructure/navigation/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // Jika tidak ada pengguna yang masuk, maka arahkan ke layar Home Pengguna
        Future.delayed(const Duration(seconds: 4), () {
          Get.offAllNamed(Routes.home);
        });
      } else {
        // Jika sudah ada pengguna yang masuk, maka arahkan ke layar Home Admin
        Get.offAllNamed(Routes.admin);
      }
    });
  }
}
