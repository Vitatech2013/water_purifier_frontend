import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/modules/home/widgets/sync_fusion_chart.dart';
import 'package:water_purifier/app/modules/sale/models/sales_response.dart';
class HomeController extends GetxController {
  final selectedIndex = 0.obs;
  final userName = 'User'.obs;
  final userEmail = 'user@example.com'.obs;
  final isowner = false.obs;
  final totalSales = <Record>[].obs;
  final salesByMonth = <String, List<Record>>{}.obs;

  // Stores total sales per month to be used in the graph
  final monthlySalesData = <SalesData>[].obs;

  Future<Map<String, String>> _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail') ?? 'user@example.com';
    final name = email.split('@').first;
    final role = prefs.getString("role") ?? "N/A";
    return {'name': name, 'email': email, 'role': role};
  }

  void loadUserInfo() async {
    final userInfo = await _getUserInfo();
    userName.value = userInfo['name'] ?? 'User';
    userEmail.value = userInfo['email'] ?? 'user@example.com';
    isowner.value = userInfo['role'] == 'owner';
  }

  Future<void> getSales() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print('Authorization token not found.');
        return;
      }

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var response = await http.get(
        Uri.parse("${AppURL.appBaseUrl}${AppURL.fetchSale}"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        SalesResponse salesResponse = SalesResponse.fromJson(jsonData);
        totalSales.assignAll(salesResponse.data);
        groupSalesByMonth(salesResponse.data);
      } else {
        print(response.body.toString());
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
    }
  }

  void groupSalesByMonth(List<Record> sales) {
    salesByMonth.clear();
    monthlySalesData.clear();  // Clear previous data

    // Initialize monthly totals with 0 sales
    Map<String, int> monthlyTotals = {
      for (var i = 1; i <= 12; i++) getMonthName(i): 0
    };

    for (var sale in sales) {
      for (var product in sale.products) {
        String monthYear = "${getMonthName(product.saleDate.month)} ${product.saleDate.year}";
        monthlyTotals[getMonthName(product.saleDate.month)] =
            (monthlyTotals[getMonthName(product.saleDate.month)] ?? 0) + 1;
      }
    }

    // Convert the monthly totals to SalesData
    monthlyTotals.forEach((month, total) {
      if(total>0){
        monthlySalesData.add(SalesData(month, total));
      }
    });
  }

  String getMonthName(int month) {
    List<String> monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }

  @override
  void onInit() {
    loadUserInfo();
    getSales();
    super.onInit();
  }
}


