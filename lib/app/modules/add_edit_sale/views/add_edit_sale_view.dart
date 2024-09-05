import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_purifier/app/modules/add_edit_sale/controllers/add_edit_sale_controller.dart';
import 'package:water_purifier/app/modules/product/models/product_response.dart';

class AddEditSaleView extends GetView<AddEditSaleController> {
  const AddEditSaleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Edit Sale'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Obx(
                  () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: controller.nameController,
                    labelText: 'Name',
                    hintText: 'Enter the customer name',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: controller.mobileNumberController,
                    labelText: 'Mobile Number',
                    hintText: 'Enter the mobile number',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildExpansionTile(
                    title: 'Products',
                    items: controller.products,
                    groupValue: controller.selectedProduct.value,
                    onChanged: controller.selectProduct,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Sale Date:'),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => controller.selectSaleDate(context),
                        child: const Text('Select Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Selected Date: ${controller.selectedDate.value.toLocal()}'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      controller.saveSale();
                    },
                    child: const Text('Save Sale'),
                  ),
                ],
              ),
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

  Widget _buildExpansionTile({
    required String title,
    required List<Datum> items,
    required String? groupValue,
    required Function(String?) onChanged,
  }) {
    return ExpansionTile(
      collapsedShape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      title: Text(title),
      children: items.map((item) {
        return RadioListTile<String>(
          title: Text(item.productName),
          value: item.productName,
          groupValue: groupValue,
          onChanged: (value) {
            onChanged(value);
            // Ensure that selectedProductId is updated
            controller.selectedProductId.value = item.id;
          },
        );
      }).toList(),
    );
  }
}
