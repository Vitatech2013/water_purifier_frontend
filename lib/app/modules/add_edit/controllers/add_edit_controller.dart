import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/modules/product/controllers/product_controller.dart';
import 'package:water_purifier/app/modules/product/models/product_response.dart';
import 'package:water_purifier/app/routes/app_pages.dart';

class AddEditController extends GetxController {
  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productPriceController = TextEditingController();
  final warrantyController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final productController = Get.find<ProductController>();

  // Image File
  Rx<File?> selectedImage = Rx<File?>(null);

  // To store the initial image URL or path
  RxString initialImage = ''.obs;

  // To store the product ID (if editing an existing product)
  RxString productId = ''.obs;

  // Error messages
  RxString productNameError = ''.obs;
  RxString productDescriptionError = ''.obs;
  RxString productPriceError = ''.obs;
  RxString warrantyError = ''.obs;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  void validateProductName() {
    if (productNameController.text.isEmpty) {
      productNameError.value = 'Product name is required';
    } else {
      productNameError.value = '';
    }
  }

  void validateProductDescription() {
    if (productDescriptionController.text.isEmpty) {
      productDescriptionError.value = 'Description is required';
    } else {
      productDescriptionError.value = '';
    }
  }

  void validateProductPrice() {
    if (productPriceController.text.isEmpty) {
      productPriceError.value = 'Price is required';
    } else {
      productPriceError.value = '';
    }
  }

  void validateWarranty() {
    if (warrantyController.text.isEmpty) {
      warrantyError.value = '';
    }
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
        // Determine if this is an add or update operation
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
        });

        if (selectedImage.value != null) {
          request.files.add(
            await http.MultipartFile.fromPath('file', selectedImage.value!.path),
          );
        } else if (initialImage.value.isNotEmpty && !isUpdating) {
          // Handle case where image is not selected but an initial image is provided
          request.fields['existingImage'] = initialImage.value;
        }

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 201 || response.statusCode == 200) {
          Get.offNamed(Routes.PRODUCT);
          productController.isEditing.value = true;
          Future.delayed(Duration(seconds: 3))
              .whenComplete(() => productController.fetchProducts());
        } else {
          Get.snackbar(
            'Save Failed',
            'Failed to ${isUpdating ? 'update' : 'add'} product.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
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
    productNameController.dispose();
    productDescriptionController.dispose();
    productPriceController.dispose();
    warrantyController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();

    // Expecting Get.arguments to return a Datum object
    final Datum? product = Get.arguments as Datum?;

    if (product != null) {
      // Safely assign values from Datum object
      productId.value = product.id ?? ''; // Assuming 'id' is the product's ID in Datum
      productNameController.text = product.productName ?? '';
      productDescriptionController.text = product.description ?? '';
      productPriceController.text = product.productPrice?.toString() ?? '';
      warrantyController.text = product.warranty ?? '';
      initialImage.value = product.productImg ?? ''; // Assuming 'productImg' holds the image URL/path
    } else {
      print('No product data found in Get.arguments');
    }
  }
}
