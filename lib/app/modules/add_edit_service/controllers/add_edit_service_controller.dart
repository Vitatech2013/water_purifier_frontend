import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/modules/service/controllers/service_controller.dart';
import 'package:water_purifier/app/routes/app_pages.dart';
import 'package:water_purifier/app/modules/service/models/service_response.dart';

class AddEditServiceController extends GetxController {
  final serviceNameController = TextEditingController();
  final serviceDescriptionController = TextEditingController();
  final servicePriceController = TextEditingController();
  final serviceController = Get.find<ServiceController>();
  final loading = false.obs;

  RxString serviceId = ''.obs;

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

    serviceNameController.addListener(validateServiceName);
    serviceDescriptionController.addListener(validateServiceDescription);
    servicePriceController.addListener(validateServicePrice);
  }

  void validateServiceName() {
    if(serviceNameController.text.isEmpty){
      serviceNameError.value = 'Service name is required';
    }
    else{
      serviceNameError.value = '';
    }
  }

  void validateServiceDescription() {
    serviceDescriptionError.value = serviceDescriptionController.text.isEmpty
        ? 'Service description is required'
        : '';
  }

  void validateServicePrice() {
    if(servicePriceController.text.isEmpty){
    servicePriceError.value ='Service price is required';
    }
    else if(!servicePriceController.text.isNum){
      servicePriceError.value='Service price should be a number';
    }else if(double.parse(servicePriceController.text)>0){
      servicePriceError.value ='Service price should be greater than zero';
    }
    else{
      servicePriceError.value="";
    }
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
        final prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
        String? ownerId = prefs.getString('ownerId');
        loading.value = true;
        if (token == null || ownerId == null) {
          print('Authorization token or owner ID not found.');
          return;
        }

        // Determine if this is an add or update operation
        final isUpdating = serviceId.value.isNotEmpty;
        final url = isUpdating
            ? '${AppURL.appBaseUrl}${AppURL.updateService}/${serviceId.value}'
            : '${AppURL.appBaseUrl}${AppURL.addService}';

        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add the authorization token
        };

        // Prepare the request body
        var body = json.encode({
          'name': serviceNameController.text,
          'description': serviceDescriptionController.text,
          'price': servicePriceController.text,
          'ownerId': ownerId, // Include ownerId in the body
        });

        // Create the request based on the action (update or add)
        var request = isUpdating
            ? http.Request('PUT', Uri.parse(url))
            : http.Request('POST', Uri.parse(url));

        request.headers.addAll(headers);
        request.body = body;

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200 || response.statusCode == 201) {
          var responseData = await response.stream.bytesToString();
          var jsonResponse = json.decode(responseData);
          print(jsonResponse['message']);
          Get.offNamed(Routes.SERVICE);
          serviceController.fetchingServices(); // Refresh services list
        } else {
          print('Failed to ${isUpdating ? 'update' : 'add'} service');
          print(response.statusCode);
        }
      } catch (e) {
        print('Error occurred: $e');
      }
      finally{
        loading.value = false;
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
