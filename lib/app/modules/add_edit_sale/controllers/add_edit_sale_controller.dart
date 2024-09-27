import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/modules/product/models/product_response.dart';
import 'package:water_purifier/app/modules/sale/controllers/sale_controller.dart';
import 'package:water_purifier/app/routes/app_pages.dart';

class AddEditSaleController extends GetxController {
  final nameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final productPriceController = TextEditingController();
  final salePriceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final saleController = Get.find<SaleController>();
  final loading = false.obs;

  RxString userId = ''.obs;
  Rx<Datum?> selectedProduct = Rx<Datum?>(null);
  RxList<Datum> products = <Datum>[].obs;
  final selectedProductId = Rx<String?>(null);

  Rx<DateTime> selectedDate = DateTime.now().obs;

  // Error messages
  RxString nameError = ''.obs;
  RxString mobileNumberError = ''.obs;
  RxString productError = ''.obs;
  RxString salePriceError = ''.obs;
  var args = {};
  @override
  void onInit() {
    super.onInit();

    fetchProducts().then((_) {
      if (Get.arguments != null && Get.arguments is Map) {
        args = Get.arguments;
        if(args["userName"] != null) {
          nameController.text = args["userName"] ?? "";
          mobileNumberController.text = args["userMobile"] ?? "";
          userId.value = args["userId"] ?? 0;
        } else {
          nameController.text = args["name"];
          mobileNumberController.text = args["mobile"];
          String productId = args["productId"];
          selectProductById(productId); // Ensure this is called after products are fetched
        }
      } else {
        nameController.text = "";
        mobileNumberController.text = "";
        userId.value = "";
      }
      print(args.toString());
    });
  }
  Future<void> sendThankYouMessage(String mobileNumber,String message) async{
    final smsUri = Uri.parse('sms:$mobileNumber?body=$message');
    if(await canLaunchUrl(smsUri)){
      await launchUrl(smsUri);
    }else{
      print("Could not send SMS to $mobileNumber");
      Get.snackbar('Error', 'Failed to send SMS. Please try again.');
    }
  }
  void selectProductById(String productId) {
    final selectedProd = products.firstWhereOrNull((product) {
      return product.id == productId;
    },);
    if (selectedProd != null) {
      selectedProduct.value = selectedProd;
      selectedProductId.value = selectedProd.id;
      productPriceController.text = selectedProd.productPrice.toString();
    }
    else {
      print("Product with id $productId not found.");
    }
  }

  void validateName() {
    nameError.value = nameController.text.isEmpty ? 'Name is required' : '';
  }

  void validateSalePrice() {
    if(salePriceController.text.isEmpty)
      {
        salePriceError.value = 'Sale Price is required';
      }
    else if(!salePriceController.text.isNum)
      {
        salePriceError.value = 'Sale price should be number';
      }
    else{
      salePriceError.value="";
    }
  }

  void validateMobileNumber() {
    final pattern = RegExp(r'^[6-9]\d{9}$');
    mobileNumberError.value = !pattern.hasMatch(mobileNumberController.text)
        ? 'Please enter a valid Indian mobile number'
        : '';
  }

  void validateFields() {
    validateName();
    validateMobileNumber();
    validateSalePrice();
    productError.value =
        selectedProductId.value == null ? 'Please select a product' : '';
  }

  void editPersonValidateField() {
    validateName();
    validateMobileNumber();
  }

  void productSelected(String value) {
    productPriceController.text = value;
  }

  Future<void> fetchProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? ownerId = prefs.getString('ownerId');

      if (token == null || ownerId == null) {
        print('Authorization token or owner ID not found.');
        return;
      }

      var request = http.Request('GET',
          Uri.parse('${AppURL.appBaseUrl}/api/product/?ownerId=$ownerId'));
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

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
        salePriceError.value.isEmpty &&
        selectedProductId.value != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
        String? ownerId = prefs.getString('ownerId');
        loading.value = true;
        if (token == null || ownerId == null) {
          print('Authorization token or owner ID not found.');
          return;
        }

        const url = '${AppURL.appBaseUrl}${AppURL.addSale}';
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };
        print("ownerId$ownerId");
        print("productId${selectedProductId.value}");
        var body = json.encode({
          "name": nameController.text,
          "mobile": mobileNumberController.text,
          "productId": selectedProductId.value ?? "",
          "saleDate": selectedDate.value.toIso8601String(),
          "salePrice": salePriceController.text,
          "ownerId": ownerId,
        });

        var request = http.Request('POST', Uri.parse(url));
        request.body = body;
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 201 || response.statusCode == 200) {
          print('Sale added successfully');
          await response.stream.bytesToString();

          sendThankYouMessage(mobileNumberController.text, 'Thank you for purchasing ${selectedProduct.value?.productName}');
          Get.offNamed(Routes.SALE);
          saleController.isEditing.value = true;
          Future.delayed(const Duration(seconds: 1))
              .whenComplete(() => saleController.fetchSales());
        } else {
          print('Failed to add sale');
          print(response.reasonPhrase);
          print(response.statusCode);
        }
      } catch (e) {
        print('Error occurred: $e');
      }finally{
        loading.value = false;
      }
    } else {
      print('Form validation failed');
    }
  }

  Future<void> editPerson() async {
    // Validate input fields if necessary
    editPersonValidateField(); // Assuming you have a validation method

    if (nameError.value.isEmpty && mobileNumberError.value.isEmpty) {
      try {
        // Fetch the token and ownerId from shared preferences
        final prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');

        if (token == null) {
          print('Authorization token not found.');
          return;
        }

        // Set up the API endpoint URL
        var url = '${AppURL.appBaseUrl}${AppURL.editPerson}$userId';

        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };

        // Prepare the body with dynamic values from text controllers
        var body = json.encode({
          "name": nameController.text,
          "mobile": mobileNumberController.text,
        });

        // Create the HTTP request
        var request = http.Request('PUT', Uri.parse(url));
        request.body = body;
        request.headers.addAll(headers);

        // Send the request and await the response
        http.StreamedResponse response = await request.send();

        // Check the response status
        if (response.statusCode == 200) {
          print('Person edited successfully');
          await response.stream.bytesToString();
          Get.offNamed(Routes.SALE);
          saleController.isEditing.value = true;
          Future.delayed(const Duration(seconds: 1))
              .whenComplete(() => saleController.fetchSales());
        } else {
          print('Failed to edit person');
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

  @override
  void onClose() {
    nameController.dispose();
    mobileNumberController.dispose();
    salePriceController.dispose();
    productPriceController.dispose();
    fetchProducts();
    super.onClose();
  }
}
