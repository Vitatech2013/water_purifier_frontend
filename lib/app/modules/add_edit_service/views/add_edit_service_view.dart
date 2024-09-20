import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_purifier/app/modules/add_edit_service/controllers/add_edit_service_controller.dart';

class AddEditServiceView extends GetView<AddEditServiceController> {
  const AddEditServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final loading = controller.loading.value;
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
        padding:  EdgeInsets.all(width*0.04),
        child: SingleChildScrollView(
          child:  Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                 SizedBox(height: width*0.03),
                Obx(
                  ()=> _buildTextField(
                    enabled: !loading,
                    controller: controller.serviceNameController,
                    labelText: 'Service Name',
                    hintText: 'Enter the service name',
                    errorText:controller.serviceNameError.value.isNotEmpty? controller.serviceNameError.value:"",
                    onChanged: (value) => controller.validateServiceName(),
                    width: width,
                  ),
                ),
                 SizedBox(height: width*0.04),
                Obx(
                  ()=> _buildTextField(
                    enabled: !loading,
                    controller: controller.serviceDescriptionController,
                    labelText: 'Service Description',
                    hintText: 'Enter a description',
                    maxLines: 3,
                    errorText: controller.serviceDescriptionError.value,
                    onChanged: (value) => controller.validateServiceDescription(),
                    width: width,
                  ),
                ),
                 SizedBox(height: width*0.04),
                Obx(
                  ()=> _buildTextField(
                    enabled: !loading,
                    controller: controller.servicePriceController,
                    labelText: 'Service Price',
                    hintText: 'Enter the price',
                    keyboardType: TextInputType.number,
                    errorText: controller.servicePriceError.value,
                    onChanged: (value) => controller.validateServicePrice(),
                    width: width,
                  ),
                ),
                 SizedBox(height: width*0.06),
                Obx(
                  ()=> FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: controller.loading.value?Colors.grey:Colors.blue,
                    ),
                    onPressed: () {
                      if(controller.loading.value==false){
                      controller.saveService();
                      }
                    },
                    child: const Text('Save Service'),
                  ),
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
    required bool enabled,
    TextInputType keyboardType = TextInputType.text,
    required String errorText,
    required ValueChanged<String> onChanged,
    required double width
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            enabled: enabled,
            labelText: labelText,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(width*0.03),
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
