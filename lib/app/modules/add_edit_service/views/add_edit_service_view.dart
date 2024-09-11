import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_purifier/app/modules/add_edit_service/controllers/add_edit_service_controller.dart';

class AddEditServiceView extends GetView<AddEditServiceController> {
  const AddEditServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: controller.serviceId.isEmpty
            ? const Text(
          "Add Service",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )
            : const Text(
          "Edit Service",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child:  Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Obx(
                  ()=> _buildTextField(
                    controller: controller.serviceNameController,
                    labelText: 'Service Name',
                    hintText: 'Enter the service name',
                    errorText:controller.serviceNameError.value.isNotEmpty? controller.serviceNameError.value:"",
                    onChanged: (value) => controller.validateServiceName(),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  ()=> _buildTextField(
                    controller: controller.serviceDescriptionController,
                    labelText: 'Service Description',
                    hintText: 'Enter a description',
                    maxLines: 3,
                    errorText: controller.serviceDescriptionError.value,
                    onChanged: (value) => controller.validateServiceDescription(),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  ()=> _buildTextField(
                    controller: controller.servicePriceController,
                    labelText: 'Service Price',
                    hintText: 'Enter the price',
                    keyboardType: TextInputType.number,
                    errorText: controller.servicePriceError.value,
                    onChanged: (value) => controller.validateServicePrice(),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    controller.saveService();
                  },
                  child: const Text('Save Service'),
                ),
              ],
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
    required String errorText,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            errorText: errorText.isNotEmpty ? errorText : null,
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
