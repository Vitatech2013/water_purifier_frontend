import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_colors.dart';

class AppUtils {
  AppUtils._();

  static Future<bool> checkInternet() async {
    final connectionResult = await Connectivity().checkConnectivity();

    if (connectionResult != ConnectivityResult.none) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } on SocketException catch (_) {
        return false;
      }
    }

    return false; // No connection or no internet access
  }

  static void showSnackBar({String? title, required String message}) {
    Get.showSnackbar(GetSnackBar(
      title: title,
      message: message,
      duration: const Duration(milliseconds: 2000),
      dismissDirection: DismissDirection.horizontal,
      animationDuration: const Duration(milliseconds: 500),
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.primaryColor,
    ));
  }

  static Future<T?> showModernDialog<T>({
    required String title,
    String? button1Text,
    String? button2Text,
    void Function()? button1Action,
    void Function()? button2Action,
  }) =>
      Get.dialog<T>(
        AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 8),
          content: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (button1Text != null)
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                          onPressed: button1Action ?? Get.back,
                          child: Text(button1Text),
                        ),
                      ),
                    if (button1Text != null && button2Text != null)
                      const SizedBox(width: 24),
                    if (button2Text != null)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: button2Action ?? Get.back,
                          child: Text(button2Text),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
