import 'package:get/get.dart';
import 'package:water_purifier/app/modules/product/controllers/product_controller.dart';
import 'package:water_purifier/app/modules/sale/controllers/sale_controller.dart';
import 'package:water_purifier/app/modules/service/controllers/service_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<ProductController>(
          () => ProductController(),
    );
    Get.lazyPut<ServiceController>(
          () => ServiceController(),
    );
    Get.lazyPut<SaleController>(
          () => SaleController(),
    );
  }
}
