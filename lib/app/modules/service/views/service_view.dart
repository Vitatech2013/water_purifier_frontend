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
          backgroundColor: Colors.blue,
        ),
        body: Obx(() {
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
              SizedBox(height: width * 0.015),
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

                    return Card(
                      elevation: width * 0.017,
                      margin: EdgeInsets.symmetric(vertical: width * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(width * 0.02),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: width * 0.04,
                            right: width * 0.04,
                            bottom: width * 0.115,
                            left: width * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.name,
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: width * 0.017),
                            Text(
                              '💰 ${service.price}',
                              style: textTheme.titleMedium?.copyWith(
                                color: Colors.green[700],
                              ),
                            ),
                            SizedBox(height: width * 0.02),
                            Text(
                              service.description,
                              style: textTheme.titleMedium?.copyWith(
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: width * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.ADD_EDIT_SERVICE,
                                        arguments: service);
                                  },
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  tooltip: 'Edit',
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller.deleteService(serviceId);
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  tooltip: 'Delete',
                                ),
                              ],
                            ),
                          ],
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
            Get.toNamed(Routes.ADD_EDIT_SERVICE);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
