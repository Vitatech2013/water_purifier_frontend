import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/core/app_config/app_utils.dart';
import 'package:water_purifier/app/modules/service/models/service_response.dart';

class ServiceController extends GetxController {
  final currentIndex = 0.obs;
  final services = <ServiceResponse>[].obs;
  final isLoading = true.obs;
  final isEditing = false.obs;
  final isInternetAvailable = true.obs;

  Future<void> fetchServices() async {
    try {
      isLoading.value = true;

      // Retrieve token and ownerId from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? ownerId = prefs.getString('ownerId');

      if (token == null || ownerId == null) {
        print('Authorization token or owner ID not found.');
        return;
      }
      final url = Uri.parse('${AppURL.appBaseUrl}${AppURL.fetchService}?ownerId=$ownerId');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add the authorization token
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> && responseData['status'] == 1) {
          final List<dynamic> servicesData = responseData['data'];
          services.value = servicesData
              .map((serviceJson) =>
              ServiceResponse.fromJson(serviceJson as Map<String, dynamic>))
              .toList();
          isEditing.value = false;
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
      isEditing.value = false;
    }
  }
  void showAlertDialogue(String serviceId) {
    AppUtils.showModernDialog(
        title: "Are you sure you want to delete",
        button1Text: "Yes",
        button1Action: () {
          deleteService(serviceId);
          Get.back();
        },
        button2Text: "No",
        button2Action: () {
          Get.back();
        });
  }

  Future<void> deleteService(String serviceId) async {
    try {
      // Retrieve token and ownerId from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? ownerId = prefs.getString('ownerId');

      if (token == null || ownerId == null) {
        print('Authorization token or owner ID not found.');
        return;
      }

      // Prepare the URL and headers with token and ownerId
      final url = Uri.parse('${AppURL.appBaseUrl}${AppURL.deleteService}$serviceId?ownerId=$ownerId');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add the authorization token
        },
      );

      if (response.statusCode == 200) {
        print('Service deleted successfully');
        isEditing.value = true;
        Future.delayed(const Duration(seconds: 1)).then((_) => deletingService());
        services.value = services.where((service) => service.id != serviceId).toList();
        services.refresh();
      } else {
        print('Failed to delete service: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred during deletion: $e');
    }
  }

  void fetchingServices() {
    isEditing.value = true;
    Future.delayed(const Duration(seconds: 1)).then(
      (_) => fetchServices(),
    );
  }
  void deletingService() {
    isEditing.value = false;
    fetchServices();
  }
  Future<void> internetAvailableAndLoadData()async{
    bool internetAvailable =await AppUtils.checkInternet();
    isInternetAvailable.value=internetAvailable;
    if(internetAvailable){
      fetchServices();
    }
  }
  @override
  void onInit() {
   internetAvailableAndLoadData();
    super.onInit();
  }
}
