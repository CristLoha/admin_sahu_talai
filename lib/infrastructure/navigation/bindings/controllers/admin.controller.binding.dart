import 'package:get/get.dart';

import '../../../../presentation/admin/controllers/admin.controller.dart';

class AdminControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminController>(
      () => AdminController(),
    );
  }
}
