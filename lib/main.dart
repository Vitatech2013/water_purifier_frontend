import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:water_purifier/app/core/app_config/app_theme.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "water_purifier",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getWaterPurifierTheme(),
      darkTheme: AppTheme.getWaterPurifierTheme(),
    ),
  );
}