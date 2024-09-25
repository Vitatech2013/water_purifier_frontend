import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:http/http.dart' as http;
import 'package:water_purifier/app/modules/technician/controllers/technician_controller.dart';
import 'dart:convert';

import 'package:water_purifier/app/routes/app_pages.dart';

class AddEditTechnicianController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final loading = false.obs;
  final id = Rx<String?>(null);
  final technician = Get.find<TechnicianController>();

  RxString nameError = ''.obs;
  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;
  RxString confirmPasswordError = ''.obs;

  void validateTechnicianName() {
    if (nameController.text.isEmpty) {
      nameError.value = 'Technician name is required';
    } else {
      nameError.value = '';
    }
  }

  void validateEmail() {
    if (emailController.text.isEmpty) {
      emailError.value = 'Email is required';
    } else if (!GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Invalid email format';
    } else {
      emailError.value = '';
    }
  }

  void validatePassword() {
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
    } else {
      passwordError.value = '';
    }
  }

  void validateConfirmPassword() {
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Confirm password is required';
    } else if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
    } else {
      confirmPasswordError.value = '';
    }
  }

  Future<void> addTechnician() async {
    validateTechnicianName();
    validateEmail();
    validatePassword();
    validateConfirmPassword();

    if (nameError.value.isNotEmpty || emailError.value.isNotEmpty || passwordError.value.isNotEmpty || confirmPasswordError.value.isNotEmpty) {
      return; 
    }

    loading.value = true;

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? ownerId = prefs.getString('ownerId');

    if (token == null || ownerId == null) {
      print('Authorization token or owner ID not found.');
      loading.value = false; 
      return;
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', 
    };
    final requestUrl = id.value ==null? Uri.parse(AppURL.appBaseUrl+AppURL.addTechnician):Uri.parse(AppURL.appBaseUrl+AppURL.editTechnician+(id.value??""));
    var request = http.Request(id.value ==null?'POST':'PUT', requestUrl);
    request.body = json.encode({
      "name":nameController.text,
      "email":emailController.text,
      "ownerId":ownerId,
      "password":passwordController.text,
    });
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.offAllNamed(Routes.TECHNICIAN);
        technician.getTechnicians();
        technician.isEditing.value=true;
        clearFields();
      } else {
        print("Error: ${response.statusCode} - ${await response.stream.bytesToString()}");
      }
    } catch (e) {
      print("Exception: ${e.toString()}");
    } finally {
      loading.value = false;
    }
  }

  void clearFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameError.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  @override
  void onInit() {
    final technicianData = Get.arguments??null;
    if(technicianData!=null)
    {
      nameController.text = technicianData.name??"";
      emailController.text = technicianData.email??"";
      id.value =technicianData.id??"";
      print(id.value.toString());
    }
    super.onInit();
  }
}
