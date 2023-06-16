import 'package:get/get.dart';

import '../../../../presentation/admin_detail/controllers/admin_detail.controller.dart';

class AdminDetailControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminDetailController>(
      () => AdminDetailController(),
    );
  }
}
