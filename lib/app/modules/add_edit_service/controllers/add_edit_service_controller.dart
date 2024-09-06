import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/routes/app_pages.dart';
import 'package:water_purifier/app/modules/service/models/service_response.dart';

class AddEditServiceController extends GetxController {
  final serviceNameController = TextEditingController();
  final serviceDescriptionController = TextEditingController();
  final servicePriceController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RxString serviceId = ''.obs; // To store the service ID if editing

  // Error messages
  RxString serviceNameError = ''.obs;
  RxString serviceDescriptionError = ''.obs;
  RxString servicePriceError = ''.obs;

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

    // Set up listeners to validate fields on change
    serviceNameController.addListener(validateServiceName);
    serviceDescriptionController.addListener(validateServiceDescription);
    servicePriceController.addListener(validateServicePrice);
  }

  void validateServiceName() {
    serviceNameError.value = serviceNameController.text.isEmpty
        ? 'Service name is required'
        : '';
  }

  void validateServiceDescription() {
    serviceDescriptionError.value = serviceDescriptionController.text.isEmpty
        ? 'Service description is required'
        : '';
  }

  void validateServicePrice() {
    servicePriceError.value = servicePriceController.text.isEmpty
        ? 'Service price is required'
        : '';
  }

  void validateFields() {
    validateServiceName();
    validateServiceDescription();
    validateServicePrice();
  }

  Future<void> saveService() async {
    validateFields();

    if (serviceNameError.value.isEmpty &&
        serviceDescriptionError.value.isEmpty &&
        servicePriceError.value.isEmpty) {
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
