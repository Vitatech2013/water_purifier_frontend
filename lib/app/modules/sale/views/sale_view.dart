import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_purifier/app/modules/sale/controllers/sale_controller.dart';
import 'package:water_purifier/app/modules/sale/models/sales_response.dart';
import 'package:water_purifier/app/routes/app_pages.dart';

class SaleView extends GetView<SaleController> {
  const SaleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale Management'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.salesList.isEmpty) {
          return const Center(child: Text('No sales found.'));
        } else {
          return ListView.builder(
            itemCount: controller.salesList.length,
            itemBuilder: (context, index) {
              final sale = controller.salesList[index];

              return Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ExpansionTile(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                  shape: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.zero)),
                  title: Text(
                    '${sale.user.name ?? 'Unknown'} - ${sale.user.mobile ?? 'No number'}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: const EdgeInsets.all(0),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Purchase Date: ${sale.createdAt.toLocal().toShortDateString()}',
                              style: const TextStyle(fontSize: 16)),
                          Text(
                              'Expiry Date: ${sale.updatedAt.toLocal().toShortDateString()}',
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Purchased Products:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextButton.icon(
                                onPressed: () {},
                                label: const Text("AddProduct",style: TextStyle(fontWeight: FontWeight.bold),),
                                icon: const Icon(Icons.add),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...sale.products.map(
                            (product) {
                              final productName = product.product != null
                                  ? (product.product?['productName'] ??
                                      'No Product Name')
                                  : 'No Product Name';
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8.0),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Image.asset("assets/waterdroppng.png",
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(productName,
                                          style: const TextStyle(fontSize: 16)),
                                    ),
                                    TextButton.icon(
                                      label: Text("AddService"),
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        _showAddProductDialog(context, product);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.ADD_EDIT_SALE, arguments: {"": ""});
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context, Product product) {
    // Example remaining products list, replace with actual data
    final remainingProducts = [
      'Product A',
      'Product B',
      'Product C',
      'Product C',
      'Product C',
      'Product C',
      'Product C',
      'Product C',
      'Product C',
      'Product C',
      'Product C',
      'Product C',
      'Product C',
      'Product C',
      'Product C',
      'Product C',
      'Product C',
      'Product C',
      'Product C',
      'Product C',
      'Product C',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height *
                  0.6, // Adjust height as needed
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Add Services to ${product.product?['productName'] ?? 'Unknown Product'}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: remainingProducts.length,
                    itemBuilder: (context, index) {
                      final remainingProduct = remainingProducts[index];
                      return ListTile(
                        title: Text(remainingProduct),
                        trailing: ElevatedButton(
                          onPressed: () {
                            // Handle adding the product
                            Navigator.pop(context); // Close the dialog
                          },
                          child: const Text('Add'),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

extension DateFormatter on DateTime {
  String toShortDateString() {
    return '${this.day}/${this.month}/${this.year}';
  }
}
