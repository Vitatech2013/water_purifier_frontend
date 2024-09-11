import 'package:get/get.dart';
import 'package:water_purifier/app/modules/home/controllers/home_controller.dart';

import '../controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(
      () => ProductController(),
    );
    Get.lazyPut<HomeController>(
          () => HomeController(),
    );
  }
}
