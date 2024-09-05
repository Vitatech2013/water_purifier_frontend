import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_purifier/app/modules/add_edit_service/controllers/add_edit_service_controller.dart';

class AddEditServiceView extends GetView<AddEditServiceController> {
  const AddEditServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Edit Service'),
        backgroundColor: Colors.blue, // Unique color
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _buildTextField(
                  controller: controller.serviceNameController,
                  labelText: 'Service Name',
                  hintText: 'Enter the service name',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: controller.serviceDescriptionController,
                  labelText: 'Service Description',
                  hintText: 'Enter a description',
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: controller.servicePriceController,
                  labelText: 'Service Price',
                  hintText: 'Enter the price',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    controller.saveService();
                  },
                  child: const Text('Save Service'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) =>
      value!.isEmpty ? 'This field is required' : null,
    );
  }
}
