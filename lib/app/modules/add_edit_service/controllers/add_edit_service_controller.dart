import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/routes/app_pages.dart';
import 'package:water_purifier/app/modules/service/models/service_response.dart'; // Ensure correct import path

class AddEditServiceController extends GetxController {
  final serviceNameController = TextEditingController();
  final serviceDescriptionController = TextEditingController();
  final servicePriceController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RxString serviceId = ''.obs; // To store the service ID if editing

  @override
  void onInit() {
    super.onInit();
    final dynamic service = Get.arguments;

    if (service is ServiceResponse) {
      serviceId.value = service.id;
      serviceNameController.text = service.name;
      serviceDescriptionController.text = service.description;
      servicePriceController.text = service.price.toString();
    } else {
      print('Unexpected type for Get.arguments: ${service.runtimeType}');
    }
  }

  Future<void> saveService() async {
    if (formKey.currentState!.validate()) {
      try {
        final isUpdating = serviceId.value.isNotEmpty;
        final url = isUpdating
            ? '${AppURL.appBaseUrl}${AppURL.updateService}/${serviceId.value}'
            : '${AppURL.appBaseUrl}${AppURL.addService}';

        // Prepare headers and request body
        var headers = {'Content-Type': 'application/json'};
        var body = json.encode({
          'name': serviceNameController.text,
          'description': serviceDescriptionController.text,
          'price': servicePriceController.text,
        });

        // Create and configure the request
        var request = isUpdating
            ? http.Request('PUT', Uri.parse(url))
            : http.Request('POST', Uri.parse(url));

        request.headers.addAll(headers);
        request.body = body;

        // Send the request and handle the response
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200 || response.statusCode == 201) {
          var responseData = await response.stream.bytesToString();
          var jsonResponse = json.decode(responseData);
          print(jsonResponse['message']);

          Get.offNamed(Routes.SERVICE); // Navigate back after success
        } else {
          print('Failed to ${isUpdating ? 'update' : 'add'} service');
          print(response.statusCode);
        }
      } catch (e) {
        print('Error occurred: $e');
      }
    } else {
      print('Form validation failed');
    }
  }

  @override
  void onClose() {
    serviceNameController.dispose();
    serviceDescriptionController.dispose();
    servicePriceController.dispose();
    super.onClose();
  }
}
