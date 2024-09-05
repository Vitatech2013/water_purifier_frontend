import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/modules/product/models/product_response.dart';
import 'package:water_purifier/app/modules/sale/models/sales_response.dart';
import 'package:water_purifier/app/modules/service/models/service_response.dart';

class SaleController extends GetxController {
  var isLoading = true.obs;
  var salesList = <Record>[].obs;
  var productList = <Datum>[].obs;
  var serviceList = <ServiceResponse>[].obs;
  final isEditing = false.obs;
  var addedServiceIds = <String>[].obs;
  Future<void> fetchSales() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse("${AppURL.appBaseUrl}${AppURL.fetchSale}"));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        SalesResponse salesResponse = SalesResponse.fromJson(jsonData);
        isEditing.value = false;
        salesList.assignAll(salesResponse.data);
      } else {
        print(response.body.toString());
      }
    } catch (e,s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
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
      final response = await http.get(Uri.parse('${AppURL.appBaseUrl}${AppURL.fetchService}'));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> && responseData['status'] == 1) {
          final List<dynamic> servicesData = responseData['data'];
          serviceList.value = servicesData.map((serviceJson) => ServiceResponse.fromJson(serviceJson as Map<String, dynamic>)).toList();
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
  Future<void> saveSale({required String name,required String mobile,required String productId,}) async {
      try {
        const url = '${AppURL.appBaseUrl}${AppURL.addSale}';
        var headers = {
          'Content-Type': 'application/json',
        };

        var body = json.encode({
          "name": name,
          "mobile": mobile,
          "productId": productId,
          "saleDate": DateTime.now().toIso8601String()
        });

        var request = http.Request('POST', Uri.parse(url));
        request.body = body;
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 201||response.statusCode==200) {
          print('Sale added successfully');
          isEditing.value=true;
          print(await response.stream.bytesToString());
          Future.delayed(3.seconds).whenComplete(()=>
              saleEdited()
          );
        } else {
          print('Failed to add sale');
          print(response.reasonPhrase);
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
  }) async {
    const String apiUrl = '${AppURL.appBaseUrl}/api/sale/addservice';
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'saleId': saleId,
      'productId': productId,
      'serviceTypeId': serviceTypeId,
      'serviceDate': DateTime.now().toIso8601String(),
      'servicePrice': servicePrice,
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
        isEditing.value=true;
        Future.delayed(3.seconds).whenComplete(()=>
            saleEdited()
        );
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
  @override
  void onInit() {
    fetchSales();
    fetchProducts();
    fetchServices();
    super.onInit();
  }
}
