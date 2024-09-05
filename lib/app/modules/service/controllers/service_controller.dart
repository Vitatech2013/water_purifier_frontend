import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/modules/service/models/service_response.dart'; // Import the model

class ServiceController extends GetxController {
  var currentIndex = 0.obs;
  var services = <ServiceResponse>[].obs; // Change to use the model
  var isLoading = true.obs;
  var serviceParameters = {}.obs; // To hold the parameters

  @override
  void onInit() {
    fetchServices();
    super.onInit();
  }

  void setTabIndex(int index, [Map<String, dynamic>? params]) {
    if (params != null) {
      serviceParameters.value = params;
    }
    currentIndex.value = index;
  }

  Future<void> fetchServices() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse('${AppURL.appBaseUrl}${AppURL.fetchService}'));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> && responseData['status'] == 1) {
          final List<dynamic> servicesData = responseData['data'];
          services.value = servicesData.map((serviceJson) => ServiceResponse.fromJson(serviceJson as Map<String, dynamic>)).toList();
        } else {
          print('Unexpected response format or status');
        }
      } else {
        print('Failed to load services: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred while fetching services: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteService(String serviceId) async {
    try {
      final response = await http.delete(Uri.parse('${AppURL.appBaseUrl}${AppURL.deleteService}$serviceId'));

      if (response.statusCode == 200) {
        print('Service deleted successfully');
        // Refresh the service list after deletion
        fetchServices();
      } else {
        print('Failed to delete service: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred during deletion: $e');
    }
  }
}
