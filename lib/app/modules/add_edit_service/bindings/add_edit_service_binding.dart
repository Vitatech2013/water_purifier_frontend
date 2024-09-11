import 'package:get/get.dart';

import 'package:water_purifier/app/modules/add_edit_service/controllers/add_edit_service_controller.dart';
import 'package:water_purifier/app/modules/service/controllers/service_controller.dart';

class AddEditServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddEditServiceController>(
      () => AddEditServiceController(),
    );
  }
}
