import 'package:get/get.dart';
import 'package:water_purifier/app/modules/signin/controllers/signin_controller.dart';

import '../controllers/add_edit_sale_controller.dart';

class AddEditSaleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddEditSaleController>(
      () => AddEditSaleController(),
    );
    Get.lazyPut<SigninController>(
          () => SigninController(),
    );
  }
}
