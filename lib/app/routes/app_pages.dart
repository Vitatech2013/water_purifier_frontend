import 'package:get/get.dart';

import '../modules/add_edit/bindings/add_edit_binding.dart';
import '../modules/add_edit/views/add_edit_view.dart';
import '../modules/add_edit_sale/bindings/add_edit_sale_binding.dart';
import '../modules/add_edit_sale/views/add_edit_sale_view.dart';
import '../modules/add_edit_service/bindings/add_edit_service_binding.dart';
import '../modules/add_edit_service/views/add_edit_service_view.dart';
import '../modules/add_edit_technician/bindings/add_edit_technician_binding.dart';
import '../modules/add_edit_technician/views/add_edit_technician_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/product_view.dart';
import '../modules/sale/bindings/sale_binding.dart';
import '../modules/sale/views/sale_view.dart';
import '../modules/service/bindings/service_binding.dart';
import '../modules/service/views/service_view.dart';
import '../modules/signin/bindings/signin_binding.dart';
import '../modules/signin/views/signin_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/technician/bindings/technician_binding.dart';
import '../modules/technician/views/technician_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => const SigninView(),
      binding: SigninBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT,
      page: () => const ProductView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE,
      page: () => const ServiceView(),
      binding: ServiceBinding(),
    ),
    GetPage(
      name: _Paths.SALE,
      page: () => const SaleView(),
      binding: SaleBinding(),
    ),
    GetPage(
      name: _Paths.ADD_EDIT,
      page: () => const AddEditView(),
      binding: AddEditBinding(),
    ),
    GetPage(
      name: _Paths.ADD_EDIT_SERVICE,
      page: () => const AddEditServiceView(),
      binding: AddEditServiceBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ADD_EDIT_SALE,
      page: () => const AddEditSaleView(),
      binding: AddEditSaleBinding(),
    ),
    GetPage(
      name: _Paths.TECHNICIAN,
      page: () => const TechnicianView(),
      binding: TechnicianBinding(),
    ),
    GetPage(
      name: _Paths.ADD_EDIT_TECHNICIAN,
      page: () => const AddEditTechnicianView(),
      binding: AddEditTechnicianBinding(),
    ),
  ];
}
