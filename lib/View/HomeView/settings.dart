import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myphone_admin/Widgets/button.dart';
import 'package:sizer/sizer.dart';

import '../../Controllers/home_controller.dart';
import '../../Widgets/app_bar.dart';
import '../../Widgets/text.dart';
import '../../colors.dart';
import '../finished_orders.dart';
import '../pending_orders.dart';
import '../processing_orders.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: const MyAppBar(title: 'Settings', leadingExists: false),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyButton(
                        buttonFunction: () {
                          Get.to(() => const PendingOrders());
                        },
                        height: 60,
                        width: 100.w,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const MyText(
                              text: 'Pending Orders',
                              size: 18,
                              weight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 24,
                              color: MyColors().mainColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      MyButton(
                        buttonFunction: () {
                          Get.to(() => const ProcessingOrders());
                        },
                        height: 60,
                        width: 100.w,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const MyText(
                              text: 'Processing Orders',
                              size: 18,
                              weight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 24,
                              color: MyColors().mainColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      MyButton(
                        buttonFunction: () {
                          Get.to(() => const FinishedOrders());
                        },
                        height: 60,
                        width: 100.w,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const MyText(
                              text: 'Finished Orders',
                              size: 18,
                              weight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 24,
                              color: MyColors().mainColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      MyButton(
                        buttonFunction: controller.signOut,
                        height: 40,
                        width: 100.w,
                        color: MyColors().mainColor,
                        child: const MyText(
                          text: 'Sign Out',
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
