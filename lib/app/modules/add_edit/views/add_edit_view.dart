import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/modules/add_edit/controllers/add_edit_controller.dart';
import 'package:water_purifier/app/routes/app_pages.dart';

class AddEditView extends GetView<AddEditController> {
  const AddEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        '${AppURL.appBaseUrl}/uploads/${controller.initialImage.value}';
    final isLocalFile = controller.initialImage.value.startsWith('file://');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                if (controller.selectedImage.value != null) {
                  return Image.file(controller.selectedImage.value!,
                      height: 150, fit: BoxFit.cover);
                } else if (isLocalFile) {
                  return Image.file(File(controller.initialImage.value),
                      height: 150, fit: BoxFit.cover);
                } else if (controller.initialImage.value.isEmpty) {
                  return GestureDetector(
                    onTap: () => controller.pickImage(ImageSource.camera),
                    child: Container(
                      height: 150,
                      width: 250,
                      color: Colors.grey[300],
                      child: Icon(Icons.camera_alt,
                          size: 50, color: Colors.grey[700]),
                    ),
                  );
                } else {
                  return InkWell(
                    onTap: ()=>controller.pickImage(ImageSource.camera),
                    child:
                        Image.network(imageUrl, height: 150, fit: BoxFit.cover),
                  );
                }
              }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.pickImage(ImageSource.gallery),
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 16),
              Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: controller.productNameController,
                      decoration:
                          const InputDecoration(labelText: 'Product Name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a product name' : null,
                    ),
                    TextFormField(
                      controller: controller.productDescriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Product Description'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a description' : null,
                    ),
                    TextFormField(
                      controller: controller.productPriceController,
                      decoration:
                          const InputDecoration(labelText: 'Product Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a price' : null,
                    ),
                    TextFormField(
                      controller: controller.warrantyController,
                      decoration: const InputDecoration(labelText: 'Warranty'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        controller.saveProduct();
                      },
                      child: const Text('Save Product'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
