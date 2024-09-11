import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:water_purifier/app/modules/home/controllers/home_controller.dart';
import 'package:water_purifier/app/routes/app_pages.dart';

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
              decoration:  BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(width*0.075),
                  topLeft: Radius.circular(width*0.075),
                ),
              ),
              child: Padding(
                padding:  EdgeInsets.all(width*0.038),
                child: SingleChildScrollView(
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
                       SizedBox(height: width*0.02), // Space between rows
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildCard(
                            width,
                            height,
                            'Sales',
                            "assets/salespng.png",
                            "Sales",
                          ),
                        ],
                      ),
                    ],
                  ),
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
    return InkWell(
      onTap: () {
        print("onTapCalled for $navigateTo");
        if (navigateTo == "Products") {
          print("Navigating to Products");
          Get.toNamed(Routes.PRODUCT);
          // Get.to(const ProductView(),transition: Transition.rightToLeftWithFade);
        } else if (navigateTo == "Services") {
          print("Navigating to Services");
          print(width);
          print(height);
          Get.toNamed(Routes.SERVICE);
          // Get.to(const ServiceView(),transition: Transition.rightToLeftWithFade);
        } else if (navigateTo == "Sales") {
          print("Navigating to Sales");
          // Get.to(const SaleView(),transition: Transition.rightToLeftWithFade);
          Get.toNamed(Routes.SALE);
        } else {
          print("Unknown navigation target: $navigateTo");
        }
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width*0.06),
        ),
        child: Container(
          width: (width * 0.4),
          height: height / 5.5, // Adjust card height
          padding:  EdgeInsets.all(width*0.04),
          child: Column(
            children: [
              Image.asset(
                image,
                height: width*0.20,
              ),
              Text(
                text,
                style:  TextStyle(fontSize: width*0.045),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
