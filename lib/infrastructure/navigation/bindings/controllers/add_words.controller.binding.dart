import 'package:get/get.dart';

import '../../../../presentation/add_words/controllers/add_words.controller.dart';

class AddWordsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddWordsController>(
      () => AddWordsController(),
    );
  }
}
