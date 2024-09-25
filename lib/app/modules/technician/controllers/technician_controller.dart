import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/core/app_config/app_utils.dart';
import 'package:water_purifier/app/modules/technician/models/technician_response.dart';

class TechnicianController extends GetxController {
  final technicians = <TechnicianResponse>[].obs;
  final isEditing = false.obs;

  Future<void> getTechnicians() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final ownerId = prefs.getString('ownerId');

    if (token == null || ownerId == null) {
      debugPrint('Error: Authorization token or owner ID not found.');
      return;
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final uri = Uri.parse("${AppURL.appBaseUrl}${AppURL.getTechnician}");
    final request = http.Request('GET', uri);
    request.headers.addAll(headers);

    try {
      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final decodedData = jsonDecode(responseBody) as List;
        technicians.clear();
        technicians.addAll(
            decodedData.map((e) => TechnicianResponse.fromJson(e)).toList());
      } else {
        debugPrint(
            'Error: Failed to fetch technicians. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      debugPrint('Exception: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isEditing.value = false;
    }
  }

  Future<void> deleteTechnician(String technicainId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        print('Authorization token or owner ID not found.');
        return;
      }
      final response = await http.delete(
          Uri.parse(
            AppURL.appBaseUrl + AppURL.deleteTechnician + technicainId,
          ),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 200) {
        print("technician deleted");
        isEditing.value =true;
        Future.delayed(const Duration(seconds: 1)).then((_)=>deletingTechnicians());
        technicians.value = technicians.where((technician)=>technician.id !=technicainId).toList();
        technicians.refresh();
      }
      else {
        print('Failed to delete technician: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred during deletion: $e');
    }
  }
    void deletingTechnicians() {
    isEditing.value = false;
    getTechnicians();
  }
    void showAlertDialogue(String technicainId) {
    AppUtils.showModernDialog(
        title: "Are you sure you want to delete",
        button1Text: "Yes",
        button1Action: () {
         deleteTechnician(technicainId);
          Get.back();
        },
        button2Text: "No",
        button2Action: () {
          Get.back();
        });
  }

  @override
  void onInit() {
    getTechnicians();
    super.onInit();
  }
}
