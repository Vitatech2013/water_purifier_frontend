import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/modules/product/models/product_response.dart';

class ProductController extends GetxController {
  var products = <Datum>[].obs;  // Using the model Datum
  var isLoading = true.obs;
  final isEditing = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
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
            isEditing.value = false;
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

  void deletingProduct() {
    isEditing.value = false;
    fetchProducts();
  }

  Future<void> deleteProduct(String productId) async {
    try {
      var request = http.Request('DELETE', Uri.parse('${AppURL.appBaseUrl}${AppURL.deleteProduct}$productId'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print('Product deleted successfully');
        isEditing.value = true;
        Future.delayed(3.seconds).then((value) => deletingProduct());
      } else {
        print('Failed to delete product: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred during deletion: $e');
    }
  }
}
