import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_purifier/app/core/app_config/app_assets.dart';
import 'package:water_purifier/app/modules/signin/controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.07),
        child: Form(
          key: controller.formKey,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Image.asset(AppAssets.loginLogo,
                  width: width / 2, height: height / 2.2),
              Text(
                "Login",
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: width * 0.03),
              Row(
                children: [
                  Text(
                    "@",
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  Expanded(
                    child: TextFormField(
                      enabled: !controller.loading.value,
                      controller: controller.emailController,
                      style: textTheme.titleLarge?.copyWith(
                        fontSize: width * 0.043,
                      ),
                      textInputAction: TextInputAction.next,
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
              SizedBox(height: width * 0.043),
              Row(
                children: [
                  const Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                  SizedBox(width: width * 0.02),
                  Expanded(
                    child: Obx(
                      () => TextFormField(
                        enabled: !controller.loading.value,
                        controller: controller.passwordController,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.043,
                        ),
                        textInputAction: TextInputAction.done,
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
                        onFieldSubmitted: (_) {
                          controller.signIn();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height / 14),
              FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.025),
                  ),
                  backgroundColor: colorScheme.primary,
                ),
                onPressed: controller.signIn,
                child: Text(
                  "Login",
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
