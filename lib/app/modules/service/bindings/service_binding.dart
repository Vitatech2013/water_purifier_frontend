import 'package:get/get.dart';
import 'package:water_purifier/app/modules/home/controllers/home_controller.dart';

import 'package:water_purifier/app/modules/service/controllers/service_controller.dart';

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceController>(
      () => ServiceController(),
    );
    Get.lazyPut<HomeController>(
          () => HomeController(),
    );
  }
}
