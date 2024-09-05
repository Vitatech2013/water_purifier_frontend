import 'package:get/get.dart';

import '../controllers/add_edit_sale_controller.dart';

class AddEditSaleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddEditSaleController>(
      () => AddEditSaleController(),
    );
  }
}
