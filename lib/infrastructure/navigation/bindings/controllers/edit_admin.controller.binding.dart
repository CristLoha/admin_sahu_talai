import 'package:get/get.dart';

import '../../../../presentation/edit_admin/controllers/edit_admin.controller.dart';

class EditAdminControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditAdminController>(
      () => EditAdminController(),
    );
  }
}
