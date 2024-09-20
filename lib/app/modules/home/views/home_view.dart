import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_purifier/app/modules/home/controllers/home_controller.dart';
import 'package:water_purifier/app/routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

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
              height: height/2.55,
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              color: Colors.blue,
              child: Column(
                children: [
                  SizedBox(height: width / 5),
                  CircleAvatar(
                    radius: width * 0.2,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: width * 0.3,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Obx(() => Text(
                        controller.userName.value,
                        style: TextStyle(
                          fontSize: width * 0.07,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      )),
                  Obx(() => Text(
                        controller.userEmail.value,
                        style: TextStyle(
                          fontSize: width * 0.045,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(height: width * 0.04),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              height: height / 1.65,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.shopping_bag_outlined),
                        title: const Text('Products'),
                        onTap: () {
                          Get.toNamed(Routes.PRODUCT);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.home_repair_service_outlined),
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
                  Column(
                    children: [
                      Text("Developed with care, delivered with love💖",style: textTheme.titleSmall,),
                      Text("Vita technologies",style: textTheme.titleLarge!.copyWith(
                        color: Colors.red.withOpacity(0.7)
                      ),),
                      SizedBox(height: 18,)
                    ],
                  ),
                ],

              ),
            ),
          ],
        ),
      ),
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
          ),
        ],
      ),
    );
  }

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
                    radius: width/6,
                    child: Icon(
                      Icons.logout,
                      // color: Colors.red,
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
                  child: const Text("Logout")),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  )),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Cancel"))
            ],
          ),
        );
      },
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
