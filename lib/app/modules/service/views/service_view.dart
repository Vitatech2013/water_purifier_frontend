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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Management'),
        backgroundColor: colorScheme.primary,
        elevation: 4.0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.services.isEmpty) {
          return const Center(child: Text('No services available.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: controller.services.length,
          itemBuilder: (context, index) {
            final service = controller.services[index];
            final serviceId = service.id;

            return Card(
              elevation: 6.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: InkWell(
                onTap: () {
                  // Handle card tap if needed
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                      const SizedBox(height: 6.0),
                      Text(
                        '💰 ${service.price}',
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        service.description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.toNamed(Routes.ADD_EDIT_SERVICE, arguments: service);
                            },
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            tooltip: 'Edit',
                          ),
                          IconButton(
                            onPressed: () {
                              // Deleting functionality
                              controller.deleteService(serviceId);
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Delete',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add new service
          Get.toNamed(Routes.ADD_EDIT_SERVICE);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
