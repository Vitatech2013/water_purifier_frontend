import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_purifier/app/core/app_config/app_date_formatters.dart';
import 'package:water_purifier/app/modules/sale/controllers/sale_controller.dart';
import 'package:water_purifier/app/routes/app_pages.dart';

class SaleView extends GetView<SaleController> {
  const SaleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.toNamed(Routes.HOME);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text(
          'Sales Management',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.salesList.isEmpty) {
          return const Center(child: Text('No sales found.'));
        } else {
          return Column(
            children: [
              controller.isEditing.value
                  ? const LinearProgressIndicator()
                  : const SizedBox(),
              Expanded(
                child: ListView.builder(
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
                          '${sale.user?.name} - ${sale.user?.mobile}',
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Purchased Products:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        elevation: 2,
                                      ),
                                      onPressed: () {
                                        _showAddProductDialog(context,
                                            sale.user!.name, sale.user!.mobile);
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        "Add Product",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ...sale.products.map((product) {
                                  final productName = product.product != null
                                      ? (product.product?.productName ??
                                          'No Product Name')
                                      : 'No Product Name';
                                  final productId = product.product != null
                                      ? (product.product?.id ??
                                          'No Product ID')
                                      : 'No Product ID';

                                  final hasServices =
                                      product.services.isNotEmpty;
                                  final services =
                                      hasServices ? product.services : null;

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12.0),
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 6,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/productpng.png",
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 28),
                                                child: Text(
                                                  productName,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 28),
                                              child: TextButton.icon(
                                                label: const Text(
                                                  "Add Service",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.teal,
                                                  ),
                                                ),
                                                icon: const Icon(
                                                  Icons.add_circle_outline,
                                                  color: Colors.teal,
                                                ),
                                                onPressed: () {
                                                  _showAddServiceDialog(context,
                                                      sale.id, productId);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Expiry Date: ${formatToMDY(product.warrantyExpiry)}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 8),
                                        if (services != null &&
                                            services.isNotEmpty) ...[
                                          const Divider(),
                                          const Text(
                                            "Services:",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: services.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 10,
                                              childAspectRatio: 3,
                                            ),
                                            itemBuilder: (context, index) {
                                              final service = services[index];
                                              return Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue[50],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: Colors.grey
                                                          .withOpacity(0.5)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.check_circle,
                                                        color: Colors.green,
                                                        size: 20),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        service.serviceType.name
                                                               ??
                                                            "N/A",
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ] else ...[
                                          const Text("No services added."),
                                        ],
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
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

  String formatToMDY(DateTime date) {
    return AppDateFormatters.dateMDY.format(date);
  }

  void _showAddProductDialog(BuildContext context, String name, String mobile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 5,
          backgroundColor: Colors.white,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(2.0),
                          topRight: Radius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        'Select Product',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.productList.length,
                        itemBuilder: (context, index) {
                          final product = controller.productList[index];
                          return ListTile(
                            title: Text(product.productName,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () {
                                controller.saveSale(
                                    name: name,
                                    mobile: mobile,
                                    productId: product.id);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Add',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.shade100,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Close',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        );
      },
    );
  }

  void _showAddServiceDialog(
      BuildContext context, String saleId, String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(2.0),
                          topRight: Radius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        'Select Service',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.serviceList.length,
                        itemBuilder: (context, index) {
                          final service = controller.serviceList[index];
                          return ListTile(
                            title: Text(service.name,
                                style: const TextStyle(fontSize: 16)),
                            trailing: TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                if (controller.addedServiceIds
                                    .contains(service.id)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${service.name} is already added.'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                } else {
                                  controller
                                      .postService(
                                    saleId: saleId,
                                    productId: productId,
                                    serviceTypeId: service.id,
                                    servicePrice: service.price.toDouble(),
                                  )
                                      .then((_) {
                                    Navigator.pop(context);
                                  });
                                }
                              },
                              child: const Text('Add',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.shade100,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        );
      },
    );
  }
}
