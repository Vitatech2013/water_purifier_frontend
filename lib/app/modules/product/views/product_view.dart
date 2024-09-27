import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/modules/product/controllers/product_controller.dart';
import 'package:water_purifier/app/routes/app_pages.dart';
import 'package:water_purifier/app/modules/product/models/product_response.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    bool isNavigating = false; // Debounce flag

    void navigateToRoute(String routeName, [dynamic arguments]) async {
      if (!isNavigating) {
        isNavigating = true;
        await Get.toNamed(routeName, arguments: arguments);
        isNavigating = false;
      }
    }

    return WillPopScope(
      onWillPop: () async {
        log('Physical back button pressed');
        Get.offAllNamed(Routes.HOME);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
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
            'Products Management',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          scrolledUnderElevation: 0,
          backgroundColor: Colors.blue,
        ),
        body: Obx(() {
          if (!controller.isInternetAvailable.value) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.signal_wifi_connected_no_internet_4,
                      size: width / 2,
                      color: Colors.redAccent,
                    ),
                    SizedBox(height: width * 0.04),
                    Text(
                      "Please check your internet connection.",
                      style: textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: width * 0.04),
                    FilledButton(
                      onPressed: () {
                        controller.internetAvailableAndLoadData();
                      },
                      child: const Text("TryAgain"),
                    )
                  ],
                ),
              ),
            );
          }
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.products.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Oops! It looks empty here. Why not add some products?",
                  style: textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }

          return Column(
            children: [
              controller.isEditing.value
                  ? const LinearProgressIndicator()
                  : const LimitedBox(),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(width * 0.02),
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final Datum product = controller.products[index];
                    final String productId = product.id ?? '';
                    final String productImg = product.productImg ?? '';
                    final String imageUrl =
                        '${AppURL.appBaseUrl}/uploads/$productImg';

                    return InkWell(
                      onTap: () {
                        Get.toNamed(Routes.ADD_EDIT, arguments: product);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: width * 0.02),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(width * 0.027),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(width * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(width * 0.02),
                                        child: Image.network(
                                          imageUrl,
                                          width: width / 4,
                                          height: width / 4,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return SizedBox(
                                                width: width / 4,
                                                height: width / 4,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            (loadingProgress
                                                                    .expectedTotalBytes ??
                                                                1)
                                                        : null,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(Icons.error,
                                                  color: Colors.red),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: width * 0.027),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            product.productName ?? '',
                                            style: textTheme.titleLarge
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: width * 0.01),
                                          Text(
                                            '💸 ${product.productPrice ?? ''}',
                                            style: textTheme.titleMedium
                                                ?.copyWith(color: Colors.green),
                                          ),
                                          SizedBox(height: width * 0.01),
                                          Text(
                                            'Warranty: ${product.warranty ?? ''} ${_getWarrantyLabel(product.warranty, product.warrantyType)}',
                                            style: textTheme.bodyMedium
                                                ?.copyWith(
                                                    color: Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Get.toNamed(Routes.ADD_EDIT,arguments: product);
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: width * 0.027),
                              Text(
                                product.description ?? '',
                                style: textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[700],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                   Row(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white, backgroundColor: product.status=="active" ? Colors.blue : Colors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {
                                            // controller.showAlertDialogue(productId);
                                          },
                                          child: Text(
                                            'Active',
                                            style: TextStyle(
                                              color: product.status=="active" ? Colors.white : Colors.black,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white, backgroundColor: product.status=="active" ? Colors.grey : Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {
                                            controller.showAlertDialogue(productId);
                                          },
                                          child: Text(
                                            'Inactive',
                                            style: TextStyle(
                                              color: product.status=="active" ? Colors.black : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToRoute(Routes.ADD_EDIT);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  String _getWarrantyLabel(int? warranty, String? warrantyType) {
    if (warranty == null || warrantyType == null) return 'Year';
    print("After null");
    if (warranty > 1) {
      if (warrantyType == "months") {
        return "Months";
      } else if (warrantyType == "years") {
        return "Years";
      }
    } else {
      if (warrantyType == "months") {
        return "Month";
      } else if (warrantyType == "years") {
        return "Year";
      }
    }
    return "";
  }
}
