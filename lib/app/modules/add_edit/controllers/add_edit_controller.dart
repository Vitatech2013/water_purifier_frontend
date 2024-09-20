import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/modules/product/controllers/product_controller.dart';
import 'package:water_purifier/app/modules/product/models/product_response.dart';
import 'package:water_purifier/app/routes/app_pages.dart';

class AddEditController extends GetxController {
  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productPriceController = TextEditingController();
  final warrantyController = TextEditingController();
  final productController = Get.find<ProductController>();
  final loading = false.obs;

  // Image File
  Rx<File?> selectedImage = Rx<File?>(null);
  RxString initialImage = ''.obs;

  // Product ID to check if editing
  RxString productId = ''.obs;

  // Edit Mode
  var isEditMode = false.obs;

  // Error messages
  RxString productNameError = ''.obs;
  RxString productDescriptionError = ''.obs;
  RxString productPriceError = ''.obs;
  RxString warrantyError = ''.obs;

  // Warranty types
  var selectedWarrantyType = 'M'.obs;
  final List<String> warrantyTypes = ["M", "Y"];

  @override
  void onInit() {
    super.onInit();
    final Datum? product = Get.arguments;

    if (product != null) {
      isEditMode.value = true;
      productId.value = product.id ?? '';
      productNameController.text = product.productName ?? '';
      productDescriptionController.text = product.description ?? '';
      productPriceController.text = product.productPrice.toString() ?? '';
      warrantyController.text = product.warranty.toString() ?? '';
      selectedWarrantyType.value =
      product.warrantyType == "months" ? "M" : "Y";
      initialImage.value = product.productImg ?? '';
    } else {
      isEditMode.value = false;
    }
  }

  // Pick Image
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  // Validation Methods
  void validateProductName() {
    productNameError.value = productNameController.text.isEmpty
        ? 'Product name is required'
        : '';
  }

  void validateProductDescription() {
    productDescriptionError.value = productDescriptionController.text.isEmpty
        ? 'Description is required'
        : '';
  }

  void validateProductPrice() {
    if(productPriceController.text.isEmpty){
      productPriceError.value = 'Product price is required';
    }
    else if(!productPriceController.text.isNum){
      productPriceError.value = 'Product price should be number';
    }
    else{
      productPriceError.value="";
    }
  }

  void validateWarranty() {
    warrantyError.value = warrantyController.text.isEmpty ? '' : '';
  }

  Future<void> saveProduct() async {
    validateProductName();
    validateProductDescription();
    validateProductPrice();

    if (productNameError.value.isEmpty &&
        productDescriptionError.value.isEmpty &&
        productPriceError.value.isEmpty) {
      if (selectedImage.value == null && initialImage.value.isEmpty) {
        Get.snackbar(
          'Image Required',
          'Please select an image to save the product.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      try {
        final prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
        String? ownerId = prefs.getString('ownerId');
        loading.value=true;

        if (token == null || ownerId == null) {
          Get.snackbar(
            'Error',
            'Authorization token or owner ID not found.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        final isUpdating = productId.value.isNotEmpty;
        final url = isUpdating
            ? '${AppURL.appBaseUrl}${AppURL.updateProducts}$productId'
            : '${AppURL.appBaseUrl}${AppURL.addProduct}';

        var request = http.MultipartRequest(
          isUpdating ? 'PUT' : 'POST',
          Uri.parse(url),
        );

        request.fields.addAll({
          'productName': productNameController.text,
          'productPrice': productPriceController.text,
          'warranty': warrantyController.text,
          'description': productDescriptionController.text,
          'warrantyType': selectedWarrantyType.value == 'M' ? 'months' : 'years',
          //'ownerId': ownerId,
        });

        // Handle image file
        if (selectedImage.value != null) {
          request.files.add(
            await http.MultipartFile.fromPath('file', selectedImage.value!.path),
          );
        } else if (initialImage.value.isNotEmpty && isUpdating) {
          // In case the image is already provided and not updated during edit
          request.fields['existingImage'] = initialImage.value;
        }

        request.headers.addAll({
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $token',  // Add the authorization token
        });

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 201 || response.statusCode == 200) {
          Get.offNamed(Routes.PRODUCT);
          productController.isEditing.value = true;
          productController.fetchProducts();
          loading.value=false;
        } else {
          print('Error: ${response.statusCode}');
          Get.snackbar(
            'Save Failed',
            'Failed to ${isUpdating ? 'update' : 'add'} product. Status: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        print('Error occurred: $e');
        Get.snackbar(
          'Save Failed',
          'An error occurred: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      finally{
        loading.value=false;
      }
    } else {
      print('Form validation failed');
    }
  }


  @override
  void onClose() {
    productNameController.dispose();
    productDescriptionController.dispose();
    productPriceController.dispose();
    warrantyController.dispose();
    super.onClose();
  }
}
