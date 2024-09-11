import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_purifier/app/core/app_config/app_date_formatters.dart';
import 'package:water_purifier/app/modules/sale/controllers/sale_controller.dart';
import 'package:water_purifier/app/modules/sale/models/sales_response.dart';
import 'package:water_purifier/app/routes/app_pages.dart';

class SaleView extends GetView<SaleController> {
  const SaleView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        log('Physical back button pressed');
        Get.offAllNamed(Routes.HOME);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.offAllNamed(Routes.HOME);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Oops! It looks empty here. Why not add some Sales?",
                  style: textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      controller.filterSalesByPhone(value); // Filter on input
                    },
                    decoration: InputDecoration(
                      labelText: 'Search by phone number',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                controller.isEditing.value
                    ? const LinearProgressIndicator()
                    : const SizedBox(),
                Expanded(
                  child: buildListView(
                      width,
                      textTheme,
                      controller.filteredSalesList.isEmpty
                          ? controller.salesList.length
                          : controller.filteredSalesList.length,
                      controller.filteredSalesList.isEmpty
                          ? controller.salesList
                          : controller.filteredSalesList),
                ),
              ],
            );
          }
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.ADD_EDIT_SALE,);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  ListView buildListView(
      double width, TextTheme textTheme, itemCount, saleIndex) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final sale = saleIndex[index];
        return Container(
          margin: EdgeInsets.all(width * 0.04),
          padding: EdgeInsets.all(width * 0.04),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(width * 0.02),
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
            leading: IconButton(
                onPressed: () {
                  Get.toNamed(Routes.ADD_EDIT_SALE, arguments: {
                    "userId": sale.user?.id,
                    "userName":sale.user?.name,
                    "userMobile":sale.user?.mobile,
                  });
                },
                icon: const Icon(Icons.edit)),
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            shape: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.zero),
            ),
            title: Text(
              '${sale.user?.name} - ${sale.user?.mobile}',
              style: TextStyle(
                  fontSize: width * 0.048, fontWeight: FontWeight.bold),
            ),
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.all(0),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Purchased Products:',
                        style: TextStyle(
                          fontSize: width * 0.043,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.028,
                              vertical: width * 0.02),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(width * 0.02),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () {
                          _showAddProductDialog(
                              context,
                              sale.user!.name,
                              sale.user!.mobile,
                              sale.products!.product.productid,
                              width);
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
                  SizedBox(height: width * 0.03),
                  ...sale.products.map((product) {
                    final productName = product.product != null
                        ? (product.product?.productName ?? 'No Product Name')
                        : 'No Product Name';
                    final productId = product.product != null
                        ? (product.product?.id ?? 'No Product ID')
                        : 'No Product ID';

                    final hasServices = product.services.isNotEmpty;
                    final services = hasServices ? product.services : null;
                    var servicesPrice = 0.0;
                    if (services != null && services.isNotEmpty) {
                      final serviceLength = product.services.length;
                      for (int i = 0; i < serviceLength; i++) {
                        servicesPrice = product.services[i].servicePrice!;
                      }
                    }
                    return Container(
                      margin: EdgeInsets.only(bottom: width * 0.03),
                      padding: EdgeInsets.all(width * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(width * 0.03),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/productpng.png",
                                width: width * 0.11,
                                height: width * 0.11,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: width * 0.025),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(top: width * 0.07),
                                  child: Text(
                                    productName,
                                    style: TextStyle(
                                      fontSize: width * 0.04,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: width * 0.07),
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
                                    _showAddServiceDialog(
                                        context, sale.id, productId, width);
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: width * 0.03),
                          // Text(
                          //   'Expiry Date: ${formatToMDY(product.warrantyExpiry)}',
                          //   style: const TextStyle(fontSize: 16),
                          // ),
                          Text(
                              "Product Price: ${product.salePrice.floor().toString() ?? "N/A"}",
                              style: textTheme.titleMedium!
                                  .copyWith(fontSize: 18)),
                          SizedBox(height: width * 0.02),
                          if (services != null && services.isNotEmpty) ...[
                            const Divider(),
                            Row(
                              children: [
                                Text("Service Price:",
                                    style: textTheme.titleMedium!
                                        .copyWith(fontSize: 18)),
                                Text(
                                  servicesPrice.floor().toString(),
                                  style: textTheme.titleMedium,
                                )
                              ],
                            ),
                            SizedBox(height: width * 0.02), //more
                            buildGridView(services, width),
                          ] else ...[
                            const Text("No services added."),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  GridView buildGridView(List<Service> services, double width) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: width * 0.025,
        crossAxisSpacing: width * 0.025,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) {
        final service = services[index];
        return Container(
          padding: EdgeInsets.all(width * 0.02),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(width * 0.02),
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: width * 0.05),
              SizedBox(width: width * 0.02),
              Expanded(
                child: Text(
                  service.serviceType?.name ?? "Not Available",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String formatToMDY(DateTime date) {
    return AppDateFormatters.dateMDY.format(date);
  }

  void _showAddProductDialog(BuildContext context, String name, String mobile,
      String productId, double width) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 0.03),
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
                      padding: EdgeInsets.all(width * 0.04),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(width * 0.005),
                          topRight: Radius.circular(width * 0.03),
                        ),
                      ),
                      child: Text(
                        'Select Product',
                        style: TextStyle(
                            fontSize: width * 0.05,
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
                                style: TextStyle(
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Row(
                              children: [
                                Text(product.productPrice.floor().toString()),
                              ],
                            ),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: productId == product.id
                                    ? Colors.grey
                                    : Colors.blue,
                              ),
                              onPressed: () {
                                productId == product.id
                                    ? controller.saveSale(
                                        name: name,
                                        mobile: mobile,
                                        productId: product.id)
                                    : Get.back();
                                Get.back();
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
                      padding: EdgeInsets.all(width * 0.04),
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
      BuildContext context, String saleId, String productId, double width) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 0.03),
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
                      padding: EdgeInsets.all(width * 0.04),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(width * 0.005),
                          topRight: Radius.circular(width * 0.03),
                        ),
                      ),
                      child: Text(
                        'Select Service',
                        style: TextStyle(
                            fontSize: width * 0.043,
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
                                style: TextStyle(fontSize: width * 0.04)),
                            trailing: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.045,
                                    vertical: width * 0.025),
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                // if (controller.addedServiceIds
                                //     .contains(service.id)) {
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(
                                //       content: Text(
                                //           '${service.name} is already added.'),
                                //       backgroundColor: Colors.redAccent,
                                //     ),
                                //   );
                                // } else {
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
                                // }
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
