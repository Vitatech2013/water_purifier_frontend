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
                if (controller.initialImage.value.isEmpty) {
                  return GestureDetector(
                    onTap: () => controller.pickImage(ImageSource.camera),
                    child: Container(
                      height: width / 2.74,
                      width: width / 1.65,
                      color: Colors.grey[300],
                      child: Icon(Icons.camera_alt,
                          size: width * 0.11, color: Colors.grey[700]),
                    ),
                  );
                } else {
                  bool isLocalFile =
                      controller.initialImage.value.startsWith('file://') ||
                          controller.initialImage.value.startsWith('/');
                  return InkWell(
                      onTap: () {
                        controller.pickImage(ImageSource.camera);
                      },
                      child: Stack(
                        children: [
                          isLocalFile
                              ? Image.file(
                                  File(controller.initialImage.value),
                                  height: width / 2.5,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  imageUrl,
                                  height: width / 2.5,
                                  fit: BoxFit.cover,
                                ),
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey,
                                size: width / 8,
                              ),
                            ),
                          ),
                        ],
                      ));
                }
              }),
              SizedBox(height: width * 0.04),
              Obx(
                () => FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        controller.loading.value ? Colors.grey : Colors.blue,
                    padding: EdgeInsets.symmetric(
                      horizontal: width / 4,
                    ),
                  ),
                  onPressed: () => controller.pickImage(ImageSource.gallery),
                  child: const Text('Gallery'),
                ),
              ),
              SizedBox(height: width * 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Obx(() {
                    return TextField(
                      controller: controller.productNameController,
                      enabled: !controller.loading.value,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width * 0.03)),
                        labelText: 'Product Name',
                        hintText: 'Enter the product name',
                        errorText: controller.productNameError.value.isNotEmpty
                            ? controller.productNameError.value
                            : null,
                      ),
                      onChanged: (value) => controller.validateProductName(),
                      textInputAction: TextInputAction.next,
                    );
                  }),
                  SizedBox(height: width * 0.03),
                  Obx(() {
                    return TextField(
                      controller: controller.productDescriptionController,
                      enabled: !controller.loading.value,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width * 0.03)),
                        labelText: 'Product Description',
                        hintText: 'Enter the product description',
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
                  SizedBox(height: width * 0.03),
                  Obx(() {
                    return TextField(
                      controller: controller.productPriceController,
                      enabled: !controller.loading.value,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width * 0.03)),
                        labelText: 'Product Price',
                        hintText: 'Enter the product price',
                        errorText: controller.productPriceError.value.isNotEmpty
                            ? controller.productPriceError.value
                            : null,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => controller.validateProductPrice(),
                      textInputAction: TextInputAction.next,
                    );
                  }),
                  SizedBox(height: width * 0.03),
                  Obx(() {
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            enabled: !controller.loading.value,
                            controller: controller.warrantyController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.03)),
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
                        SizedBox(width: width * 0.06),
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
                  SizedBox(height: width * 0.05),
                  Obx(
                    () => FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: controller.loading.value
                              ? Colors.grey
                              : Colors.blue),
                      onPressed: () {
                        if (controller.loading.value == false) {
                          controller.saveProduct();
                        }
                      },
                      child: const Text('Save Product'),
                    ),
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
