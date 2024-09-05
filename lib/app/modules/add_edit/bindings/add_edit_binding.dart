import 'package:get/get.dart';

import '../controllers/add_edit_controller.dart';

class AddEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddEditController>(
      () => AddEditController(),
    );
  }
}
