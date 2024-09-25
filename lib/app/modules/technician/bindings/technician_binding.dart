import 'package:get/get.dart';

import '../controllers/technician_controller.dart';

class TechnicianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TechnicianController>(
      () => TechnicianController(),
    );
  }
}
