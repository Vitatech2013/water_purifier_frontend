import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:water_purifier/app/core/app_config/app_colors.dart';
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
    final height = MediaQuery.of(context).size.height;
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
          backgroundColor: colorScheme.primary,
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
                      child: Padding(
                        padding: EdgeInsets.only(
                        left: width * 0.01,
                        right: width * 0.01,
                        top: width * 0.015,
                        bottom: index == controller.products.length - 1
                        ? width * 0.20
                        : width * 0.015,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.cardColor.withOpacity(0.8),
                            border: Border.all(
                                color: Colors.black.withOpacity(0.1)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10.0,
                                blurStyle: BlurStyle.outer,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(width * 0.04),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: height / 4,
                                      width: width / 2.5,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                              return Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                child: Container(
                                                  width: width / 4,
                                                  height: width / 4,
                                                  color: Colors.white,
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
                                    ),
                                  ],
                                ),
                                SizedBox(width: width * 0.04),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              product.productName.capitalize ?? '',
                                              style: textTheme.titleLarge
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Icon(
                                            Icons.edit,
                                            size: width * 0.065,
                                            color: colorScheme.primary
                                          )
                                        ],
                                      ),
                                      SizedBox(height: width * 0.02),
                                      Text(
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        product.description.capitalize ?? '',
                                        style: textTheme.titleMedium?.copyWith(
                                            color: Colors.grey[600],
                                            fontSize: width * 0.035),
                                      ),
                                      SizedBox(height: width * 0.01),
                                      Text(
                                        '₹${product.productPrice ?? ''}',
                                        style: textTheme.titleMedium?.copyWith(
                                            color: Colors.green,
                                            fontSize: width * 0.045),
                                      ),
                                      Text(
                                        'Warranty: ${product.warranty ?? ''} ${_getWarrantyLabel(product.warranty, product.warrantyType)}',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: width * 0.015),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: FilledButton(
                                              style: FilledButton.styleFrom(
                                                shape: product.status ==
                                                        "active"
                                                    ? null
                                                    : RoundedRectangleBorder(
                                                        side: const BorderSide(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    width *
                                                                        0.018)),
                                                backgroundColor:
                                                    product.status == "active"
                                                        ? colorScheme.primary
                                                        : Colors.white,
                                                padding: EdgeInsets.zero,
                                              ),
                                              onPressed: () {
                                                if (product.status ==
                                                    "inactive") {
                                                  controller.showAlertDialogue(
                                                      productId, "Active");
                                                }
                                              },
                                              child: Text(
                                                "Active",
                                                style: textTheme.labelSmall!
                                                    .copyWith(
                                                        fontSize: width * 0.025,
                                                        color: product.status ==
                                                                "active"
                                                            ? Colors.white
                                                            : Colors.black),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: width * 0.02),
                                          Expanded(
                                            child: FilledButton(
                                              style: FilledButton.styleFrom(
                                                  shape: product.status ==
                                                          "inactive"
                                                      ? null
                                                      : RoundedRectangleBorder(
                                                          side:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      width *
                                                                          0.018)),
                                                  backgroundColor:
                                                      product.status ==
                                                              "inactive"
                                                          ? colorScheme.primary
                                                          : Colors.white,
                                                  padding: EdgeInsets.zero),
                                              onPressed: () {
                                                if (product.status ==
                                                    "active") {
                                                  controller.showAlertDialogue(
                                                      productId, "InActive");
                                                }
                                              },
                                              child: Text(
                                                "InActive",
                                                style: textTheme.labelMedium!
                                                    .copyWith(
                                                        fontSize: width*0.025,
                                                        color: product.status ==
                                                                "inactive"
                                                            ? Colors.white
                                                            : Colors.black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
          backgroundColor: colorScheme.primary,
          onPressed: () {
            navigateToRoute(Routes.ADD_EDIT);
          },
          child: const Icon(Icons.add,color: Colors.white,),
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
