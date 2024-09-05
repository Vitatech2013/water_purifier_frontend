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


  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> saveProduct() async {
    if (formKey.currentState!.validate()) {
      try {
        // Determine if this is an add or update operation
        final isUpdating = productId.value.isNotEmpty;
        print(isUpdating);
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

        if (response.statusCode == 201||response.statusCode==200) {
          print('${isUpdating ? 'Product updated' : 'Product added'} successfully');
          print(await response.stream.bytesToString());
          Get.offNamed(Routes.PRODUCT);
          productController.isEditing.value=true;
          Future.delayed(3.seconds).whenComplete(() => productController.fetchProducts(),);
        } else {
          print('Failed to ${isUpdating ? 'update' : 'add'} product');
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
    productNameController.dispose();
    productDescriptionController.dispose();
    productPriceController.dispose();
    warrantyController.dispose();
    super.onClose();
  }
  @override
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
