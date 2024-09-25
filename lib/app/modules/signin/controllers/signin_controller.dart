import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_purifier/app/core/app_config/app_urls.dart';
import 'package:water_purifier/app/core/app_config/app_utils.dart';
import 'package:water_purifier/app/routes/app_pages.dart';

class SigninController extends GetxController {
  final passwordVisibility = false.obs;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 2) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<void> signIn() async {
    if (validateForm()) {
      loading.value=true;
      var headers = {
        'Content-Type': 'application/json',
      };
      var request = http.Request(
        'POST',
        Uri.parse(AppURL.appBaseUrl + AppURL.login),
      );
      request.body = json.encode({
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        loading.value=false;
        String responseBody = await response.stream.bytesToString();
        var decodedResponse = jsonDecode(responseBody);
        print(decodedResponse["role"]);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', emailController.text.trim());
        await prefs.setString("ownerId", decodedResponse["_id"]);
        await prefs.setString("token", decodedResponse["token"]);
        await prefs.setString("role",decodedResponse["role"]);
        String email = emailController.text.trim();
        String username = email.split('@')[0];
        AppUtils.showSnackBar(title:'Welcome, $username!',message:'Hi $username, Here you can go!' );
        Get.offAllNamed(Routes.HOME);
      } else {
        loading.value = false;
        Get.snackbar('Login Failed', 'Invalid email or password');
      }
    }
  }
}
