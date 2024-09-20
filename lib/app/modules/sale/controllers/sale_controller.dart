import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/core/app_config/app_utils.dart';
import 'package:water_purifier/app/modules/product/models/product_response.dart';
import 'package:water_purifier/app/modules/sale/models/sales_response.dart';
import 'package:water_purifier/app/modules/service/models/service_response.dart';

class SaleController extends GetxController {
  var isLoading = true.obs;
  var salesList = <Record>[].obs;
  var filteredSalesList = <Record>[].obs;
  var productList = <Datum>[].obs;
  var serviceList = <ServiceResponse>[].obs;
  final isEditing = false.obs;
  var addedServiceIds = <String>[].obs;
  var phoneNumberFilter = ''.obs;
  final isInternetAvailable = true.obs;
  final phoneNumberController = TextEditingController();
  Future<void> fetchSales() async {
    try {
      isLoading(true);

      // Retrieve token from shared preferences or environment
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print('Authorization token not found.');
        return;
      }

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Add your token here
      };

      var response = await http.get(
        Uri.parse("${AppURL.appBaseUrl}${AppURL.fetchSale}"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        SalesResponse salesResponse = SalesResponse.fromJson(jsonData);
        isEditing.value = false;
        salesList.assignAll(salesResponse.data);
      } else {
        print(response.body.toString());
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
    } finally {
      isLoading(false);
    }
  }
  // Filter sales based on phone number
  void filterSalesList() {
    if (phoneNumberFilter.isEmpty) {
      filteredSalesList.assignAll(salesList);
    } else {
      filteredSalesList.assignAll(salesList.where((sale) =>
          sale.user!.mobile.contains(phoneNumberFilter.value)));
    }
  }

  // Update phone number filter and apply filter
  void filterSalesByPhone(String phoneNumber) {
    phoneNumberFilter.value = phoneNumber;
    filterSalesList();
  }
  Future<void> fetchProducts() async {
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

      // Prepare the URL with ownerId as a query parameter
      final url = Uri.parse('${AppURL.appBaseUrl}${AppURL.fetchProducts}?ownerId=$ownerId');

      // Add the authorization token to the headers
      final headers = {
        'Authorization': 'Bearer $token', // Add the token here
      };

      var request = http.Request('GET', url);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final decodedData = json.decode(responseData);

        if (decodedData is Map<String, dynamic>) {
          final productResponse = ProductResponse.fromJson(decodedData);
          if (productResponse.data.isNotEmpty) {
            productList.value = productResponse.data;
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

      // Retrieve token and ownerId from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? ownerId = prefs.getString('ownerId');

      if (token == null || ownerId == null) {
        print('Authorization token or owner ID not found.');
        return;
      }

      // Prepare the URL with ownerId as a query parameter
      final url = Uri.parse('${AppURL.appBaseUrl}${AppURL.fetchService}?ownerId=$ownerId');

      // Add the authorization token to the headers
      final headers = {
        'Authorization': 'Bearer $token', // Add the token here
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> && responseData['status'] == 1) {
          final List<dynamic> servicesData = responseData['data'];
          serviceList.value = servicesData
              .map((serviceJson) => ServiceResponse.fromJson(serviceJson as Map<String, dynamic>))
              .toList();
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
  Future<void> saveSale({
    required String name,
    required String mobile,
    required String productId,
    required String salePrice,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? ownerId = prefs.getString('ownerId');

      if (token == null || ownerId == null) {
        print('Authorization token or owner ID not found.');
        return;
      }

      const url = '${AppURL.appBaseUrl}${AppURL.addSale}';

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Add the token here
      };

      // Include ownerId in the request body
      var body = json.encode({
        "name": name,
        "mobile": mobile,
        "productId": productId,
        "saleDate": DateTime.now().toIso8601String(),
        "salePrice": salePrice,
        "ownerId": ownerId, // Add ownerId to the body
      });

      var request = http.Request('POST', Uri.parse(url));
      request.body = body;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Sale added successfully');
        isEditing.value = true;
        print(await response.stream.bytesToString());
        Future.delayed(3.seconds).whenComplete(() => saleEdited());
      } else {
        print('Failed to add sale');
        print(response.reasonPhrase);
        print(response.statusCode);
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
  Future<void> postService({
    required String saleId,
    required String productId,
    required String serviceTypeId,
    required double servicePrice,
    required double salePrice,
  }) async {
    const String apiUrl = '${AppURL.appBaseUrl}${AppURL.addServiceInsideSale}';

    // Retrieve token and ownerId from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? ownerId = prefs.getString('ownerId');

    if (token == null || ownerId == null) {
      print('Authorization token or owner ID not found.');
      return;
    }

    // Add token to the headers
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Add the token
    };

    // Include ownerId in the request body
    final body = json.encode({
      'saleId': saleId,
      'productId': productId,
      'serviceTypeId': serviceTypeId,
      'serviceDate': DateTime.now().toIso8601String(),
      'servicePrice': servicePrice,
      'salePrice':salePrice,
      'ownerId': ownerId, // Add ownerId
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Response: ${response.body}');
        addedServiceIds.add(serviceTypeId);
        isEditing.value = true;
        Future.delayed(3.seconds).whenComplete(() => saleEdited());
      } else {
        print('Error: ${response.reasonPhrase}');
        print('Error: ${response.body}');
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }
  void saleEdited(){
    fetchSales();
    fetchServices();
    isEditing.value=false;
  }
  Future<void> internetAvailableAndLoadData()async{
    bool internetAvailable =await AppUtils.checkInternet();
    isInternetAvailable.value=internetAvailable;
    if(internetAvailable){
      fetchSales();
      fetchProducts();
      fetchServices();
    }
  }
  @override
  void onInit() {
   internetAvailableAndLoadData();
    super.onInit();
  }
}
