import 'package:get/get.dart';

import '../controllers/add_edit_technician_controller.dart';

class AddEditTechnicianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddEditTechnicianController>(
      () => AddEditTechnicianController(),
    );
  }
}
