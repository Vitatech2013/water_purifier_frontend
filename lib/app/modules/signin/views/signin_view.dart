import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_purifier/app/modules/signin/controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Form(
          key: controller.formKey,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Image.asset("assets/loginlogo.jpg"),
              Text(
                "Login",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    "@",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: controller.emailController,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: "Email ID",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(),
                      ),
                      validator: controller.validateEmail,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Obx(
                          () => TextFormField(
                        controller: controller.passwordController,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        obscureText: !controller.passwordVisibility.value,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: const UnderlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.passwordVisibility.value =
                              !controller.passwordVisibility.value;
                            },
                            icon: Icon(
                              controller.passwordVisibility.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        validator: controller.validatePassword,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height / 14),
              FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: controller.signIn,
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
