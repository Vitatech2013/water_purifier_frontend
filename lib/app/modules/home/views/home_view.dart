import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_purifier/app/routes/app_pages.dart';

import 'package:water_purifier/app/modules/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
        final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffcccccc),
      body: Column(
        children: [
          Container(
            height: height / 1.85,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/homepagelogo2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildCard(
                          width,
                          height,
                          'Products',
                          "assets/productpng.png",
                          "Products",
                        ),
                        buildCard(
                          width,
                          height,
                          'Services',
                          "assets/supportpng.png",
                          "Services",
                        ),
                      ],
                    ),
                    const SizedBox(height: 20), // Space between rows
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildCard(
                          width,
                          height,
                          'Sales',
                          "assets/salespng.png",
                          "Sales",
                        ),
                        buildCard(
                          width,
                          height,
                          'All',
                          "assets/productpng.png",
                          "All",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to Build Card
  Widget buildCard(
      double width,
      double height,
      String text,
      String image,
      String navigateTo,
      ) {
    return GestureDetector(
      onTap: () {
        print("onTapCalled for $navigateTo");
        if (navigateTo == "Products") {
          print("Navigating to Products");
          Get.toNamed(Routes.PRODUCT);
        } else if (navigateTo == "Services") {
          print("Navigating to Services");
          Get.toNamed(Routes.SERVICE);
        } else if (navigateTo == "Sales") {
          print("Navigating to Sales");
          Get.toNamed(Routes.SALE);
        } else if (navigateTo == "All") {
          print("Navigating to All");
          Get.toNamed(Routes.SERVICE);
        } else {
          print("Unknown navigation target: $navigateTo");
        }
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: (width * 0.4), // Adjust card width
          height: height / 5.5, // Adjust card height
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(
                image,
                height: 80,
              ),
              Text(
                text,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
