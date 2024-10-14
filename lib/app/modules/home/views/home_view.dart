import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:water_purifier/app/modules/home/controllers/home_controller.dart';
import 'package:water_purifier/app/modules/home/widgets/sync_fusion_chart.dart';
import 'package:water_purifier/app/routes/app_pages.dart';
import 'package:share_plus/share_plus.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: height / 3.5,
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              color: colorScheme.primary,
              child: Column(
                children: [
                  SizedBox(height: width / 5),
                  CircleAvatar(
                    radius: width * 0.1,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: width * 0.1,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Obx(() => Text(
                        controller.userName.value,
                        style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      )),
                  Obx(() => Text(
                        controller.userEmail.value,
                        style: TextStyle(
                          fontSize: width * 0.03,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      )),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              height: height / 1.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Column(
                      children: [
                        if (controller.isOwner.value)
                          ListTile(
                            leading: const Icon(Icons.shopping_bag_outlined),
                            title: const Text('Products'),
                            onTap: () {
                              Get.toNamed(Routes.PRODUCT);
                            },
                          ),
                        if (controller.isOwner.value)
                          ListTile(
                            leading:
                                const Icon(Icons.home_repair_service_outlined),
                            title: const Text('Services'),
                            onTap: () {
                              Get.toNamed(Routes.SERVICE);
                            },
                          ),
                        ListTile(
                          leading: const Icon(Icons.attach_money),
                          title: const Text('Sales'),
                          onTap: () {
                            Get.toNamed(Routes.SALE);
                          },
                        ),
                        if (controller.isOwner.value)
                          ListTile(
                            leading: const Icon(Icons.engineering_outlined),
                            title: const Text('Technicians'),
                            onTap: () {
                              Get.toNamed(Routes.TECHNICIAN);
                            },
                          ),
                        ListTile(
                          leading: const Icon(Icons.share),
                          title: const Text('Share App'),
                          onTap: () {
                            Share.share(
                                'Check out waterPurifier: https://play.google.com/store/apps/details?id=com.vitasoft.Mygallerybook');
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Logout'),
                          onTap: () {
                            Get.back();
                            _showLogoutBottomSheet(context, width, height);
                          },
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "Developed with care, delivered with love💖",
                        style: textTheme.titleSmall,
                      ),
                      Text(
                        "Vita technologies",
                        style: textTheme.titleLarge!.copyWith(
                          color: Colors.red.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: width * 0.04),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xffcccccc),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Column(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: height / 2.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/homepagelogo2.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Shimmer effect for the lower half
              Shimmer.fromColors(
                baseColor: Colors.blue[300]!,
                highlightColor: Colors.blue[100]!,
                child: Container(
                  height: height / 2.0,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(width * 0.075),
                      topLeft: Radius.circular(width * 0.075),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          // Normal state when data is loaded
          return Column(
            children: [
              Container(
                height: height / 2.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/homepagelogo2.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: controller.isOwner.value
                    ? _buildOwnerContent(width, height, colorScheme)
                    : _buildSalesOnlyContent(width, height, colorScheme),
              ),
            ],
          );
        }
      }),

    );
  }

  // Build Owner's view content with Products, Services, Sales, and Technician
  Widget _buildOwnerContent(
      double width, double height, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(width * 0.075),
          topLeft: Radius.circular(width * 0.075),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(width * 0.075),
          topLeft: Radius.circular(width * 0.075),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
          child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(width * 0.038),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildCard(width, height, 'Products',
                            "assets/productpng.png", "Products"),
                        buildCard(width, height, 'Services',
                            "assets/supportpng.png", "Services"),
                      ],
                    ),
                    SizedBox(height: width * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildCard(width, height, 'Sales', "assets/salespng.png",
                            "Sales"),
                        buildCard(width, height, 'Technicians',
                            "assets/technician.png", "Technician"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build Non-owner's view content with Sales only
  Widget _buildSalesOnlyContent(
      double width, double height, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(width * 0.075),
            topLeft: Radius.circular(width * 0.075)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: ListTile(
                  leading: Image.asset("assets/salespng.png"),
                  title: const Text("Sales"),
                  trailing: CircleAvatar(
                    child: IconButton(
                      onPressed: () {
                        Get.toNamed(Routes.SALE);
                        print(controller.monthlySalesData.toString());
                      },
                      icon: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
                child: SyncFusionChart(salesData: controller.monthlySalesData)),
          ],
        ),
      ),
    );
  }

  // Logout bottom sheet method
  void _showLogoutBottomSheet(
      BuildContext context, double width, double height) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(width * 0.05),
          height: height * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: width / 6,
                    child: Icon(
                      Icons.logout,
                      size: width * 0.2,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              FilledButton(
                onPressed: () async {
                  var prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Get.offAllNamed(Routes.SIGNIN);
                },
                child: const Text("Logout"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
        );
      },
    );
  }

  // Reusable card widget
  Widget buildCard(double width, double height, String text, String image,
      String navigateTo) {
    return InkWell(
      onTap: () {
        if (navigateTo == "Products") {
          Get.toNamed(Routes.PRODUCT);
        } else if (navigateTo == "Services") {
          Get.toNamed(Routes.SERVICE);
        } else if (navigateTo == "Sales") {
          Get.toNamed(Routes.SALE);
        } else if (navigateTo == "Technician") {
          Get.toNamed(Routes.TECHNICIAN);
        }
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * 0.06),
        ),
        child: Container(
          width: (width * 0.4),
          height: height / 5.5,
          padding: EdgeInsets.all(width * 0.04),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  image,
                  height: width * 0.20,
                ),
                Text(
                  text,
                  style: TextStyle(fontSize: width * 0.045),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
