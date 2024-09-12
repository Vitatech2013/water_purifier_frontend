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
            height: height / 2.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/homepagelogo2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(width * 0.075),
                  topLeft: Radius.circular(width * 0.075),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(width * 0.038),
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
                    SizedBox(height: width * 0.02),
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
        ],
      ),
    );
  }

  Widget buildCard(
      double width,
      double height,
      String text,
      String image,
      String navigateTo,
      ) {
    return InkWell(
      onTap: () {
        if (navigateTo == "Products") {
          Get.toNamed(Routes.PRODUCT);
        } else if (navigateTo == "Services") {
          Get.toNamed(Routes.SERVICE);
        } else if (navigateTo == "Sales") {
          Get.toNamed(Routes.SALE);
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
    );
  }
}
