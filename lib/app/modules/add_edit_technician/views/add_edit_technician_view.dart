import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_edit_technician_controller.dart';

class AddEditTechnicianView extends GetView<AddEditTechnicianController> {
  const AddEditTechnicianView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final loading = controller.loading.value;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title:  Obx(
          ()=> Text(
           controller.isEditing.value? 'Add Technician':'Edit Technician',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor:colorScheme.primary,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: SingleChildScrollView(
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
                    labelText: 'Technician Email',
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
             controller.isEditing.value?Obx(
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
              ):const LimitedBox(),
              SizedBox(height: width * 0.04),
            controller.isEditing.value?Obx(
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
              ):const LimitedBox(),
              SizedBox(height: width * 0.04),
              FilledButton(
                onPressed: loading ? null : () => controller.addTechnician(),
                child: const Text("Save Technician"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
