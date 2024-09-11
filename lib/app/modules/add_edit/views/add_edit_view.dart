import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/modules/add_edit/controllers/add_edit_controller.dart';

class AddEditView extends GetView<AddEditController> {
  const AddEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final imageUrl =
        '${AppURL.appBaseUrl}/uploads/${controller.initialImage.value}';
    final isLocalFile = controller.initialImage.value.startsWith('file://');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Obx(() => controller.isEditMode.value
            ? const Text("Edit Product",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
            : const Text("Add Product",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold))),
        leading: IconButton(
          onPressed: () {
            Get.back();
            print(width);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                if (controller.selectedImage.value != null) {
                  print("Inside selectedImage");
                  return Image.file(controller.selectedImage.value!,
                      height: width/2.74, fit: BoxFit.cover);
                } else if (isLocalFile) {
                  return Image.file(File(controller.initialImage.value),
                      height: width/2.74, fit: BoxFit.cover);
                } else if (controller.initialImage.value.isEmpty) {
                  return GestureDetector(
                    onTap: () => controller.pickImage(ImageSource.camera),
                    child: Container(
                      height: width/2.74,
                      width: width/1.65,
                      color: Colors.grey[300],
                      child: Icon(Icons.camera_alt,
                          size: width*0.11, color: Colors.grey[700]),
                    ),
                  );
                } else {
                  return InkWell(
                    onTap: () {
                      print("Inside network");
                      controller.pickImage(ImageSource.camera);
                    },
                    child:
                        Image.network(imageUrl, height: 150, fit: BoxFit.cover),
                  );
                }
              }),
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                  horizontal: 102,
                )),
                onPressed: () => controller.pickImage(ImageSource.gallery),
                child: const Text('Gallery'),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Obx(() {
                    return TextField(
                      controller: controller.productNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: 'Product Name',
                        errorText: controller.productNameError.value.isNotEmpty
                            ? controller.productNameError.value
                            : null,
                      ),
                      onChanged: (value) => controller.validateProductName(),
                      textInputAction: TextInputAction.next,
                    );
                  }),
                  const SizedBox(height: 12),
                  Obx(() {
                    return TextField(
                      controller: controller.productDescriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: 'Product Description',
                        errorText:
                            controller.productDescriptionError.value.isNotEmpty
                                ? controller.productDescriptionError.value
                                : null,
                      ),
                      onChanged: (value) =>
                          controller.validateProductDescription(),
                      textInputAction: TextInputAction.next,
                    );
                  }),
                  const SizedBox(height: 12),
                  Obx(() {
                    return TextField(
                      controller: controller.productPriceController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: 'Product Price',
                        errorText: controller.productPriceError.value.isNotEmpty
                            ? controller.productPriceError.value
                            : null,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => controller.validateProductPrice(),
                      textInputAction: TextInputAction.next,
                    );
                  }),
                  const SizedBox(height: 12),
                  Obx(() {
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.warrantyController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              labelText: 'Warranty',
                              errorText:
                                  controller.warrantyError.value.isNotEmpty
                                      ? controller.warrantyError.value
                                      : null,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => controller.validateWarranty(),
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Obx(() {
                            return DropdownButton<String>(
                              borderRadius: BorderRadius.circular(12),
                              value: controller.selectedWarrantyType.value,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  controller.selectedWarrantyType.value =
                                      newValue;
                                }
                              },
                              items: controller.warrantyTypes
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child:
                                      Text(value == "M" ? "Months" : "Years"),
                                );
                              }).toList(),
                              isExpanded: true,
                            );
                          }),
                        )
                      ],
                    );
                  }),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      controller.saveProduct();
                    },
                    child: const Text('Save Product'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
