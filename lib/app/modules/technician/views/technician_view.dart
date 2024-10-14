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
    final colorScheme = Theme.of(context).colorScheme;
    return WillPopScope(
      onWillPop: () async {
        log('Physical back button pressed');
        Get.offAllNamed(Routes.HOME);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
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
          backgroundColor: colorScheme.primary,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.technicians.isEmpty) {
            return Column(
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  itemCount: controller.technicians.length,
                  itemBuilder: (context, index) {
                    final technician = controller.technicians[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == controller.technicians.length - 1
                            ? width * 0.20
                            : width * 0.02,
                      ),
                      child: InkWell(
                        onTap: (){
                          Get.toNamed(Routes.ADD_EDIT_TECHNICIAN,
                              arguments: technician);
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: colorScheme.primary,
                              child:
                                  const Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(
                              technician.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(technician.email,style:  TextStyle(fontSize: width*0.03,),),
                            trailing: Wrap(
                              spacing: 12, // space between edit and delete icons
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      color: colorScheme.primary),
                                  onPressed: () {
                                    Get.toNamed(Routes.ADD_EDIT_TECHNICIAN,
                                        arguments: technician);
                                  },
                                ),
                                IconButton(
                                  icon:
                                      const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    controller.showAlertDialogue(
                                        technician.id, technician.name);
                                  },
                                ),
                              ],
                            ),
                          ),
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
          backgroundColor: colorScheme.primary,
          onPressed: () {
            Get.toNamed(Routes.ADD_EDIT_TECHNICIAN);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
