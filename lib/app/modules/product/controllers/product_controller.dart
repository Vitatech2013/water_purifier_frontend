import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/core/app_config/app_utils.dart';
import 'package:water_purifier/app/modules/product/models/product_response.dart';

class ProductController extends GetxController {
  var products = <Datum>[].obs;
  var isLoading = true.obs;
  final isEditing = false.obs;
  final isInternetAvailable = true.obs;
  final isActive = false.obs;

  @override
  void onInit() {
    super.onInit();
    internetAvailableAndLoadData();
  }
  Future<void> internetAvailableAndLoadData()async{
    bool internetAvailable =await AppUtils.checkInternet();
    isInternetAvailable.value=internetAvailable;
    if(internetAvailable){
      fetchProducts();
    }
  }
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        print('Authorization token not found');
        return;
      }
      var request = http.Request(
          'GET', Uri.parse(AppURL.appBaseUrl + AppURL.fetchProducts));
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final decodedData = json.decode(responseData);

        if (decodedData is Map<String, dynamic>) {
          final productResponse = ProductResponse.fromJson(decodedData);
          products.value = productResponse.data;
          isEditing.value = false;
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
      isEditing.value = false;
    }
  }

  void deletingProduct() {
    isEditing.value = false;
    fetchProducts();
  }

  void fetchingProducts() {
    isEditing.value = true;
    Future.delayed(const Duration(seconds: 1)).then((_) => fetchProducts());
  }

  void showAlertDialogue(String id) {
    AppUtils.showModernDialog(
        title: "Are you sure you want to Inactive",
        button1Text: "Yes",
        button1Action: () {
          deleteProduct(id);
          Get.back();
        },
        button2Text: "No",
        button2Action: () {
          Get.back();
        });
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        print('Authorization token not found');
        return;
      }
      var request = http.Request('DELETE',
          Uri.parse('${AppURL.appBaseUrl}${AppURL.deleteProduct}$productId'));
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print('Product deleted successfully');
        isEditing.value = true;
        Future.delayed(const Duration(seconds: 1))
            .then((_) => deletingProduct());
        products.value =
            products.where((product) => product.id != productId).toList();
        products.refresh();
      } else {
        print('Failed to delete product: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred during deletion: $e');
    }
  }
}
