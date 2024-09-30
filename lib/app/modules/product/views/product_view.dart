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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 6.0),
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
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 190,
                                      width: 135,
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
                                                baseColor:
                                                Colors.grey[300]!,
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
                                          errorBuilder: (context, error,
                                              stackTrace) {
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
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: ConstrainedBox(
                                    constraints:
                                    const BoxConstraints(minHeight: 190),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            product.productName != null
                                                ? Expanded(
                                              child: Text(
                                                product.productName ??
                                                    '',
                                                style: textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
                                                ),
                                                maxLines: 2,
                                                overflow:
                                                TextOverflow
                                                    .ellipsis,
                                              ),
                                            )
                                                : Shimmer.fromColors(
                                              baseColor:
                                              Colors.grey[300]!,
                                              highlightColor:
                                              Colors.grey[100]!,
                                              child: Container(
                                                width:
                                                double.infinity,
                                                height: 20.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.edit,
                                              size: 23.0,
                                              color: Colors.blue,
                                            )
                                          ],
                                        ),
                                        SizedBox(height: width * 0.01),
                                        const SizedBox(height: 4.0),
                                        product.description != null
                                            ? Text(
                                          maxLines: 2,
                                          overflow:
                                          TextOverflow.ellipsis,
                                          product.description ?? '',
                                          style: textTheme
                                              .titleMedium
                                              ?.copyWith(
                                              color: Colors
                                                  .grey[600],
                                              fontSize: 14.0),
                                        )
                                            : Shimmer.fromColors(
                                          baseColor:
                                          Colors.grey[300]!,
                                          highlightColor:
                                          Colors.grey[100]!,
                                          child: Container(
                                            width: double.infinity,
                                            height: 15.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        product.productPrice != null
                                            ? Text(
                                          '₹${product.productPrice ?? ''}',
                                          style: textTheme
                                              .titleMedium
                                              ?.copyWith(
                                              color:
                                              Colors.green,
                                              fontSize: 18.0),
                                        )
                                            : Shimmer.fromColors(
                                          baseColor:
                                          Colors.grey[300]!,
                                          highlightColor:
                                          Colors.grey[100]!,
                                          child: Container(
                                            width: 80.0,
                                            height: 20.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        product.warranty != null
                                            ? Text(
                                          'Warranty: ${product.warranty ?? ''} ${_getWarrantyLabel(product.warranty, product.warrantyType)}',
                                          style: textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                        )
                                            : Shimmer.fromColors(
                                          baseColor:
                                          Colors.grey[300]!,
                                          highlightColor:
                                          Colors.grey[100]!,
                                          child: Container(
                                            width: 120.0,
                                            height: 15.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed:
                                                product.status != null
                                                    ? () {}
                                                    : null,
                                                style: ElevatedButton
                                                    .styleFrom(
                                                  foregroundColor:
                                                  Colors.white,
                                                  backgroundColor:
                                                  product.status ==
                                                      "active"
                                                      ? Colors.blue
                                                      : Colors.grey,
                                                  shape:
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(8),
                                                  ),
                                                ),
                                                child: product.status !=
                                                    null
                                                    ? Text(
                                                  'Active',
                                                  style: TextStyle(
                                                    color: product.status ==
                                                        "active"
                                                        ? Colors
                                                        .white
                                                        : Colors
                                                        .black,
                                                  ),
                                                )
                                                    : Shimmer.fromColors(
                                                  baseColor: Colors
                                                      .grey[300]!,
                                                  highlightColor:
                                                  Colors.grey[
                                                  100]!,
                                                  child: Container(
                                                    width: 80.0,
                                                    height: 15.0,
                                                    color: Colors
                                                        .white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8.0),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed:
                                                product.status != null
                                                    ? () {
                                                  controller
                                                      .showAlertDialogue(
                                                      productId);
                                                }
                                                    : null,
                                                style: ElevatedButton
                                                    .styleFrom(
                                                  foregroundColor:
                                                  Colors.white,
                                                  backgroundColor:
                                                  product.status ==
                                                      "active"
                                                      ? Colors.grey
                                                      : Colors.blue,
                                                  shape:
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(8),
                                                  ),
                                                ),
                                                child: product.status !=
                                                    null
                                                    ? Text(
                                                  'Inactive',
                                                  style: TextStyle(
                                                    color: product.status ==
                                                        "active"
                                                        ? Colors
                                                        .black
                                                        : Colors
                                                        .white,
                                                  ),
                                                )
                                                    : Shimmer.fromColors(
                                                  baseColor: Colors
                                                      .grey[300]!,
                                                  highlightColor:
                                                  Colors.grey[
                                                  100]!,
                                                  child: Container(
                                                    width: 80.0,
                                                    height: 15.0,
                                                    color: Colors
                                                        .white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
