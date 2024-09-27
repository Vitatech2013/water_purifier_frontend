import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_purifier/app/modules/add_edit_sale/controllers/add_edit_sale_controller.dart';
import 'package:water_purifier/app/modules/product/models/product_response.dart';

class AddEditSaleView extends GetView<AddEditSaleController> {
  const AddEditSaleView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final loading = controller.loading.value;
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
        title: Obx(
          () => Text(
            controller.userId.isEmpty ? 'Add Sales' : 'Edit Person',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: width * 0.03),
                TextField(
                  enabled: !loading,
                  controller: controller.nameController,
                  textInputAction: TextInputAction.next,
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
                  onChanged: (value)=>controller.validateName,
                ),
                SizedBox(height: width * 0.04),
                TextField(
                  enabled: !loading,
                  controller: controller.mobileNumberController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    hintText: 'Enter the mobile number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                    ),
                    errorText: controller.mobileNumberError.value.isNotEmpty
                        ? controller.mobileNumberError.value
                        : null,
                  ),
                  onChanged: (value)=>controller.validateMobileNumber,
                ),
                SizedBox(height: width * 0.04),
                controller.userId.isEmpty
                    ? _buildExpansionTile(
                        title: 'Products',
                        items: controller.products,
                        groupValue:
                            controller.selectedProduct.value?.productName ?? "",
                        width: width,
                        onChanged: (value) {
                          final selectedProduct = controller.products
                              .firstWhere(
                                  (product) => product.productName == value);
                          controller.productSelected(
                              selectedProduct.productPrice.toString());
                          controller.selectedProduct.value = selectedProduct;
                          controller.selectedProductId.value =
                              selectedProduct.id;
                        },
                        errorText: controller.productError.value,
                      )
                    : const LimitedBox(),
                SizedBox(height: width * 0.04),
                controller.userId.isEmpty
                    ? TextField(
                        enabled: !loading,
                        controller: controller.productPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Product price',
                          hintText: 'Enter product price',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                          errorText: controller.productError.value.isNotEmpty
                              ? controller.productError.value
                              : null,
                        ),
                        readOnly: true,
                      )
                    : const LimitedBox(),
                SizedBox(height: width * 0.04),
                controller.userId.isEmpty
                    ? TextField(
                        enabled: !loading,
                        controller: controller.salePriceController,
                        keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: 'Sale price',
                          hintText: 'Enter sale price',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                          errorText: controller.salePriceError.value.isNotEmpty
                              ? controller.salePriceError.value
                              : null,
                        ),
                  onChanged: (value)=>controller.validateSalePrice,
                      )
                    : const LimitedBox(),
                SizedBox(height: width * 0.04),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: loading ? Colors.grey : Colors.blue,
                  ),
                  onPressed: () {
                    controller.userId.isEmpty
                        ? controller.saveSale()
                        : controller.editPerson();
                  },
                  child: Text(
                    controller.userId.isEmpty ? 'Save Sale' : 'Edit Person',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
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
    required double width,
  }) {
    return ExpansionTile(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(width * 0.03),
      ),
      collapsedShape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(width * 0.03),
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
            //   ),
          ],
        ),
      ],
    );
  }
}
