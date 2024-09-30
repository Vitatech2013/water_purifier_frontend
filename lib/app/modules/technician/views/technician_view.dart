import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_purifier/app/modules/technician/controllers/technician_controller.dart';
import 'package:water_purifier/app/routes/app_pages.dart';

class TechnicianView extends GetView<TechnicianController> {
  const TechnicianView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () async {
        log('Physical back button pressed');
        Get.offAllNamed(Routes.HOME);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.offAllNamed(Routes.HOME);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'Technician Management',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          scrolledUnderElevation: 0,
          backgroundColor: Colors.blue,
        ),
        body: Obx(() {
          if(controller.isLoading.value)
            {
              return const Center(child: CircularProgressIndicator());
            }
         else if (controller.technicians.isEmpty) {
            return  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Oops! It looks empty here. Why not add some technician?",
                  style: textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }
          return Column(
            children: [
              SizedBox(height: width * 0.015),
              controller.isEditing.value
                  ? const LinearProgressIndicator()
                  : const LimitedBox(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  itemCount: controller.technicians.length,
                  itemBuilder: (context, index) {
                    final technician = controller.technicians[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          technician.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(technician.email),
                        trailing: Wrap(
                          spacing: 12, // space between edit and delete icons
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.grey),
                              onPressed: () {
                                Get.toNamed(Routes.ADD_EDIT_TECHNICIAN, arguments: technician);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                controller.showAlertDialogue(technician.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.ADD_EDIT_TECHNICIAN);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
