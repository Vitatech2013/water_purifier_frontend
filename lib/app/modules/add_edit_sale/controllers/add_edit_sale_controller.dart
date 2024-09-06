import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:telephony/telephony.dart';
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/modules/product/models/product_response.dart';
import 'package:water_purifier/app/modules/sale/controllers/sale_controller.dart';
import 'package:water_purifier/app/routes/app_pages.dart';
import 'package:permission_handler/permission_handler.dart'; // Import permission_handler package

class AddEditSaleController extends GetxController {
  final nameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final saleController = Get.find<SaleController>();

  RxString saleId = ''.obs;
  RxString selectedProduct = ''.obs;
  RxString selectedService = ''.obs;
  RxList<Datum> products = <Datum>[].obs;
  final selectedProductId = Rx<String?>(null);

  final telephony = Telephony.instance;

  Rx<DateTime> selectedDate = DateTime.now().obs;

  // Error messages
  RxString nameError = ''.obs;
  RxString mobileNumberError = ''.obs;
  RxString productError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic> sale = Get.arguments ?? {};
    saleId.value = sale['id'] ?? '';
    nameController.text = sale['name'] ?? '';
    mobileNumberController.text = sale['mobileNumber'] ?? '';
    fetchProducts();

    nameController.addListener(_validateName);
    mobileNumberController.addListener(_validateMobileNumber);
  }

  void _validateName() {
    nameError.value = nameController.text.isEmpty
        ? 'Name is required'
        : '';
  }

  void _validateMobileNumber() {
    final pattern = RegExp(r'^[6-9]\d{9}$');
    mobileNumberError.value = !pattern.hasMatch(mobileNumberController.text)
        ? 'Please enter a valid Indian mobile number'
        : '';
  }

  void validateFields() {
    _validateName();
    _validateMobileNumber();
    productError.value = selectedProductId.value == null ? 'Please select a product' : '';
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
      var request = http.Request('GET', Uri.parse('${AppURL.appBaseUrl}/api/product/'));
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
    validateFields();

    if (nameError.value.isEmpty &&
        mobileNumberError.value.isEmpty &&
        productError.value.isEmpty &&
        selectedProductId.value != null) {
      try {
        const url = '${AppURL.appBaseUrl}${AppURL.addSale}';
        var headers = {'Content-Type': 'application/json'};
        var body = json.encode({
          "name": nameController.text,
          "mobile": mobileNumberController.text,
          "productId": selectedProductId.value ?? "",
          "saleDate": selectedDate.value.toIso8601String(),
        });

        var request = http.Request('POST', Uri.parse(url));
        request.body = body;
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 201 || response.statusCode == 200) {
          print('Sale added successfully');
          await response.stream.bytesToString();
          await sendSaleMessage(mobileNumberController.text, selectedProduct.value);
          Get.offNamed(Routes.SALE);
          saleController.isEditing.value = true;
          Future.delayed(Duration(seconds: 3)).whenComplete(() => saleController.fetchSales());
        } else {
          print('Failed to add sale');
          print(response.reasonPhrase);
          print(response.statusCode);
        }
      } catch (e) {
        print('Error occurred: $e');
      }
    } else {
      print('Form validation failed');
    }
  }

  bool _isValidIndianMobileNumber(String number) {
    final pattern = RegExp(r'^[6-9]\d{9}$');
    return pattern.hasMatch(number);
  }

  Future<void> sendSaleMessage(String recipient, String productName) async {
    final PermissionStatus permissionStatus = await Permission.sms.request();

    if (permissionStatus.isGranted) {
      try {
        final message = 'Thank you for purchasing $productName. Your sale has been registered.';
        telephony.sendSms(
          to: recipient,
          message: message,
        );
        print('SMS sent successfully');
      } catch (e) {
        print('Error sending SMS: $e');
      }
    } else {
      print('SMS permissions not granted');
      Get.snackbar('Error', 'SMS permission not granted');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    mobileNumberController.dispose();
    super.onClose();
  }
}
