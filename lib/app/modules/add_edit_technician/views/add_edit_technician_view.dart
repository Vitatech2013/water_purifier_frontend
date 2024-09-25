import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_purifier/app/routes/app_pages.dart';
import '../controllers/add_edit_technician_controller.dart';

class AddEditTechnicianView extends GetView<AddEditTechnicianController> {
  const AddEditTechnicianView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    final loading = controller.loading.value;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Add Technician',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: width * 0.02),
            Obx(
              () => TextField(
                enabled: !loading,
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: 'Technician Name',
                  hintText: 'Enter the technician name',
                  errorText: controller.nameError.value.isEmpty ? null : controller.nameError.value,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.03),
                  ),
                ),
                onChanged: (value) => controller.validateTechnicianName(),
                textInputAction: TextInputAction.next,
              ),
            ),
            SizedBox(height: width * 0.04),
            Obx(
              () => TextField(
                enabled: !loading,
                controller: controller.emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter the email',
                  errorText: controller.emailError.value.isEmpty ? null : controller.emailError.value,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.03),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => controller.validateEmail(),
                textInputAction: TextInputAction.next,
              ),
            ),
            SizedBox(height: width * 0.04),
            Obx(
              () => TextField(
                enabled: !loading,
                controller: controller.passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter the password',
                  errorText: controller.passwordError.value.isEmpty ? null : controller.passwordError.value,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.03),
                  ),
                ),
                obscureText: true,
                onChanged: (value) => controller.validatePassword(),
                textInputAction: TextInputAction.next,
              ),
            ),
            SizedBox(height: width * 0.04),
            Obx(
              () => TextField(
                enabled: !loading,
                controller: controller.confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter the password',
                  errorText: controller.confirmPasswordError.value.isEmpty ? null : controller.confirmPasswordError.value,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.03),
                  ),
                ),
                obscureText: true,
                onChanged: (value) => controller.validateConfirmPassword(),
                textInputAction: TextInputAction.done,
              ),
            ),
            SizedBox(height: width * 0.04),
            FilledButton(
              onPressed: loading ? null : () => controller.addTechnician(),
              child: const Text("Add Technician"),
            ),
          ],
        ),
      ),
    );
  }
}
