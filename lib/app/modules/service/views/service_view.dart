import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_purifier/app/modules/service/controllers/service_controller.dart';
import 'package:water_purifier/app/routes/app_pages.dart';

class ServiceView extends GetView<ServiceController> {
  const ServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
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
            'Services Management',
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

          if (controller.services.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Oops! It looks empty here. Why not add some Services?",
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
                  itemCount: controller.services.length,
                  itemBuilder: (context, index) {
                    final service = controller.services[index];
                    final serviceId = service.id;
                    return Padding(
                      padding: EdgeInsets.only(bottom: index == controller.services.length - 1
                          ? width * 0.20
                          : width * 0.06,),
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(Routes.ADD_EDIT_SERVICE,
                              arguments: service);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(width * 0.03),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: width * 0.01,
                              right: width * 0.01,
                              top: width * 0.015,
                            ),
                            child: Padding(
                              padding:  EdgeInsets.all(width * 0.04),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header Row with Service Name and Edit Icon
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          service.serviceName,
                                          style: textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      IconButton(
                                        style: IconButton.styleFrom(
                                            padding: EdgeInsets.zero),
                                        onPressed: () {
                                          Get.toNamed(Routes.ADD_EDIT_SERVICE,
                                              arguments: service);
                                        },
                                        icon:  Icon(Icons.edit,
                                            color: colorScheme.primary),
                                        tooltip: 'Edit',
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: width * 0.015),

                                  // Service Description
                                  Text(
                                    service.serviceDescription,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[700],
                                      fontSize: width * 0.038,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: width * 0.025),

                                  // Service Price
                                  Text(
                                    '₹${service.servicePrice}',
                                    style: textTheme.titleMedium?.copyWith(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.w600,
                                      fontSize: width * 0.045,
                                    ),
                                  ),
                                  SizedBox(height: width * 0.03),

                                  // Status Action Buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FilledButton(
                                          style: FilledButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              side: service.status == "active"
                                                  ? BorderSide.none
                                                  : const BorderSide(
                                                      color: Colors.grey),
                                              borderRadius: BorderRadius.circular(
                                                  width * 0.02),
                                            ),
                                            backgroundColor:
                                                service.status == "active"
                                                    ? colorScheme.primary
                                                    : Colors.white,
                                            padding: EdgeInsets.symmetric(
                                                vertical: width * 0.02),
                                          ),
                                          onPressed: () {
                                            if (service.status == "inactive") {
                                              controller.showAlertDialogue(
                                                  serviceId, "Active");
                                            }
                                          },
                                          child: Text(
                                            "Active",
                                            style: textTheme.labelSmall!.copyWith(
                                              fontSize: width * 0.028,
                                              color: service.status == "active"
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: width * 0.04),
                                      Expanded(
                                        child: FilledButton(
                                          style: FilledButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              side: service.status == "inactive"
                                                  ? BorderSide.none
                                                  : const BorderSide(
                                                      color: Colors.grey),
                                              borderRadius: BorderRadius.circular(
                                                  width * 0.02),
                                            ),
                                            backgroundColor:
                                                service.status == "inactive"
                                                    ? colorScheme.primary
                                                    : Colors.white,
                                            padding: EdgeInsets.symmetric(
                                                vertical: width * 0.02),
                                          ),
                                          onPressed: () {
                                            if (service.status == "active") {
                                              controller.showAlertDialogue(
                                                  serviceId, "InActive");
                                            }
                                          },
                                          child: Text(
                                            "InActive",
                                            style:
                                                textTheme.labelMedium!.copyWith(
                                              fontSize: width * 0.028,
                                              color: service.status == "inactive"
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w600,
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
            Get.toNamed(Routes.ADD_EDIT_SERVICE);
          },
          child: const Icon(Icons.add,color: Colors.white,),
        ),
      ),
    );
  }
}
