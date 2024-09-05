import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/modules/product/models/product_response.dart';
import 'package:water_purifier/app/modules/sale/models/sales_response.dart';
import 'package:water_purifier/app/modules/service/models/service_response.dart';

class SaleController extends GetxController {
  var salesList = <Record>[].obs;
  var products = <Datum>[].obs;
  var services = <ServiceResponse>[].obs;
  var isLoading = true.obs;

  Future<void> fetchSales() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse("${AppURL.appBaseUrl}${AppURL.fetchSale}"));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        SalesResponse salesResponse = SalesResponse.fromJson(jsonData);

        // Assign fetched data to the observable list
        salesList.assignAll(salesResponse.data);
      } else {
        print(response.body.toString());
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching sales');
    } finally {
      isLoading(false);
    }
  }
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      var request = http.Request('GET', Uri.parse(AppURL.appBaseUrl + AppURL.fetchProducts));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final decodedData = json.decode(responseData);

        if (decodedData is Map<String, dynamic>) {
          final productResponse = ProductResponse.fromJson(decodedData);
          if (productResponse.data.isNotEmpty) {
            products.value = productResponse.data;  // Assigning the list of Datum
            // isEditing.value = false;
          } else {
            print('No products found.');
          }
        } else {
          print('Unexpected response format: ${decodedData.runtimeType}');
        }
      } else {
        print('Failed to load products: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred: $e');
    } finally {
      isLoading.value = false;
    }
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
  @override
  void onInit() {
    fetchSales();
    super.onInit();
  }
}
