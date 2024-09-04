import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../Controllers/auth_controller.dart';
import '../../Widgets/button.dart';
import '../../Widgets/text.dart';
import '../../Widgets/text_form_field.dart';
import '../../colors.dart';
import '../../common_functions.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) {
        if (controller.signInError) {
          Future.microtask(
            () => CommonFunctions().showDialogue(controller.signInError,
                controller.errorText, null, controller.exitDialogue, null),
          );
        }
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyText(
                            text: 'welcome,'.tr,
                            size: 22,
                            weight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          MyText(
                            text: 'sign in to continue'.tr,
                            size: 18,
                            weight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      MyField(
                        width: 100.w,
                        controller: controller.signInEmailController,
                        hintText: 'email'.tr,
                        isPassword: false,
                        isLast: false,
                        isName: false,
                        type: TextInputType.text,
                        prefixIcon: const Icon(
                          Icons.email,
                          size: 24,
                          color: Colors.black,
                        ),
                        suffixIcon: null,
                        suffixIconFunction: null,
                        validatorFunction: CommonFunctions().validateEmail,
                      ),
                      const SizedBox(height: 20),
                      MyField(
                        width: 100.w,
                        controller: controller.signInPasswordController,
                        hintText: 'password'.tr,
                        isPassword: true,
                        showPassword: controller.showPasswordLogin,
                        isLast: true,
                        isName: false,
                        type: TextInputType.text,
                        prefixIcon: const Icon(
                          Icons.lock,
                          size: 24,
                          color: Colors.black,
                        ),
                        suffixIcon: controller.showPasswordLogin
                            ? const Icon(
                                CupertinoIcons.eye,
                                size: 24,
                                color: Colors.black,
                              )
                            : const Icon(
                                CupertinoIcons.eye_slash_fill,
                                size: 24,
                                color: Colors.black,
                              ),
                        suffixIconFunction:
                            controller.showPasswordFunctionLogin,
                        validatorFunction: CommonFunctions().validatePassword,
                      ),
                      const SizedBox(height: 40),
                      MyButton(
                        buttonFunction: () {
                          if (controller.loginFormKey.currentState!
                              .validate()) {
                            controller.signIn();
                          }
                        },
                        height: 40,
                        width: 100.w,
                        color: MyColors().mainColor,
                        disabled: controller.isLoading,
                        child: (controller.isLoading)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  MyText(
                                    text: 'signing in'.tr,
                                    size: 16,
                                    weight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ],
                              )
                            : MyText(
                                text: 'sign in'.tr,
                                size: 16,
                                weight: FontWeight.normal,
                                color: Colors.white,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
