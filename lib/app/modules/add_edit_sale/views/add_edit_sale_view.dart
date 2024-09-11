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
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title:  Text(
          controller.args.isEmpty?'Add Sales':'Edit Person',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Obx(
                    () => TextField(
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter the customer name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorText: controller.nameError.value.isNotEmpty
                        ? controller.nameError.value
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                    () => TextField(
                  controller: controller.mobileNumberController,
                    keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    hintText: 'Enter the mobile number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorText: controller.mobileNumberError.value.isNotEmpty
                        ? controller.mobileNumberError.value
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
             controller.args.isEmpty? Obx(
                ()=> _buildExpansionTile(
                  title: 'Products',
                  items: controller.products,
                  groupValue: controller.selectedProduct.value,
                  onChanged: (value) {
                    final selectedProduct = controller.products
                        .firstWhere((product) => product.productName == value);
                    controller.productSelected(selectedProduct.productPrice.toString());
                    controller.selectedProduct(value);
                    controller.selectedProductId.value = selectedProduct.id;
                  },
                  errorText: controller.productError.value,
                ),
              ):const LimitedBox(),
              const SizedBox(height: 16),
            controller.args.isEmpty?  Obx(
                    () => TextField(
                  controller: controller.productPriceController,
                    keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Product price',
                    hintText: 'Enter product price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorText: controller.productError.value.isNotEmpty
                        ? controller.productError.value
                        : null,
                  ),
                  readOnly: true,
                ),
              ):LimitedBox(),
              const SizedBox(height: 16),
             controller.args.isEmpty? Obx(
                    () => TextField(
                  controller: controller.salePriceController,
                    keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Sale price',
                    hintText: 'Enter sale price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorText: controller.salePriceError.value.isNotEmpty
                        ? controller.salePriceError.value
                        : null,
                  ),
                ),
              ):LimitedBox(),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                 controller.args.isEmpty? controller.saveSale(): controller.editPerson();
                },
                child:  Text(
                  controller.args.isEmpty?'Save Sale':'Edit Person',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required List<Datum> items,
    required String groupValue,
    required void Function(String) onChanged,
    required String errorText,
  }) {
    return ExpansionTile(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      collapsedShape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      title: Text(title),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var item in items)
              RadioListTile<String>(
                title: Text(item.productName),
                value: item.productName,
                groupValue: groupValue,
                onChanged: (value) {
                  onChanged(value ?? '');
                },
              ),
            // if (errorText.isNotEmpty)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            //     child: Text(
            //       errorText,
            //       style: TextStyle(color: Colors.red, fontSize: 12),
            //     ),
            //   ),
          ],
        ),
      ],
    );
  }
}
