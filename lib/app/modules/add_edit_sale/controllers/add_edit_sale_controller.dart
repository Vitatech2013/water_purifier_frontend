import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/modules/product/models/product_response.dart';
import 'package:water_purifier/app/routes/app_pages.dart';

class AddEditSaleController extends GetxController {
  final nameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RxString saleId = ''.obs;
  RxString selectedProduct = ''.obs;
  RxString selectedService = ''.obs;

  RxList<Datum> products = <Datum>[].obs;
  RxMap<String, String> services = <String, String>{}.obs;

  final selectedProductId = Rx<String?>(null);

  Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic> sale = Get.arguments ?? {};
    saleId.value = sale['id'] ?? '';
    nameController.text = sale['name'] ?? '';
    mobileNumberController.text = sale['mobileNumber'] ?? '';

    fetchProducts();
  }

  void selectProduct(String? value) {
    selectedProduct.value = value ?? '';
    selectedProductId.value = products.firstWhere((product) => product.productName == value).id;
  }

  Future<void> selectSaleDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
    }
  }

  Future<void> fetchProducts() async {
    try {
      var request =
      http.Request('GET', Uri.parse('${AppURL.appBaseUrl}/api/product/'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var data = jsonDecode(responseBody);

        ProductResponse productResponse = ProductResponse.fromJson(data);

        products.assignAll(productResponse.data);
      } else {
        print('Failed to fetch products: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }


  Future<void> saveSale() async {
    if (formKey.currentState!.validate()) {
      try {
        const url = '${AppURL.appBaseUrl}${AppURL.addSale}';

        var headers = {
          'Content-Type': 'application/json',
        };

        var body = json.encode({
          "name": nameController.text,
          "mobile": mobileNumberController.text,
          "productId": selectedProductId.value ?? "",
          "saleDate": selectedDate.value.toIso8601String() // Ensure the date format matches the server's expectations
        });

        var request = http.Request('POST', Uri.parse(url));
        request.body = body;
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 201) {
          print('Sale added successfully');
          print(await response.stream.bytesToString());
          Get.offNamed(Routes.SALE);
        } else {
          print('Failed to add sale');
          print(response.reasonPhrase);
        }
      } catch (e) {
        print('Error occurred: $e');
      }
    } else {
      print('Form validation failed');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    mobileNumberController.dispose();
    super.onClose();
  }
}
