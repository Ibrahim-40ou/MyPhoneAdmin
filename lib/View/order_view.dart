import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myphone_admin/Controllers/home_controller.dart';
import 'package:myphone_admin/Widgets/button.dart';
import 'package:myphone_admin/Widgets/text.dart';
import 'package:myphone_admin/common_functions.dart';
import 'package:sizer/sizer.dart';
import '../Models/order.dart';
import '../Models/product.dart';
import '../Widgets/app_bar.dart';
import '../Widgets/informational_bit.dart';
import '../Widgets/page_entrance.dart';
import '../colors.dart';
import 'order_products.dart';

class OrderView extends StatelessWidget {
  final MyOrder order;
  final List<Product> products;
  final bool? isPending;
  const OrderView({
    super.key,
    required this.order,
    required this.products,
    this.isPending = false,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: const MyAppBar(
              title: 'Order',
              leadingExists: true,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InformationalBit(
                        dataPoint: 'Order ID',
                        information: order.orderId!,
                      ),
                      const SizedBox(height: 20),
                      InformationalBit(
                        dataPoint: 'User ID',
                        information: order.userId!,
                      ),
                      const SizedBox(height: 20),
                      InformationalBit(
                        dataPoint: 'Recipient Name',
                        information: order.recipientFullName!,
                      ),
                      const SizedBox(height: 20),
                      InformationalBit(
                        dataPoint: 'Recipient Number',
                        information: order.phoneNumber!,
                      ),
                      const SizedBox(height: 20),
                      InformationalBit(
                        dataPoint: 'Governorate',
                        information: order.governorate!,
                      ),
                      const SizedBox(height: 20),
                      InformationalBit(
                        dataPoint: 'Closest Known Point',
                        information: order.closestKnownPoint!,
                      ),
                      const SizedBox(height: 20),
                      InformationalBit(
                        dataPoint: 'Status',
                        information: order.status!,
                      ),
                      const SizedBox(height: 20),
                      InformationalBit(
                        dataPoint: 'Date Ordered',
                        information: order.date!,
                      ),
                      const SizedBox(height: 20),
                      InformationalBit(
                        dataPoint: 'Total Price',
                        information: '\$${order.totalPrice!}',
                      ),
                      PageEntrance(
                        color: Colors.white,
                        textColor: Colors.black,
                        iconColor: MyColors().mainColor,
                        order: order,
                        name: 'Order Products',
                        function: () {
                          Get.to(() => OrderProducts(products: products));
                        },
                      ),
                    ],
                  ),
                  (isPending == true)
                      ? MyButton(
                          disabled: controller.processingOrder,
                          buttonFunction: () async {
                            await controller.processOrder(order, products);
                            Get.back();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 20,
                                ),
                                content: const Row(
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 24,
                                    ),
                                    SizedBox(width: 8),
                                    MyText(
                                      text:
                                          'Order is moved to Processing Orders',
                                      size: 16,
                                      weight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                duration: const Duration(seconds: 3),
                                backgroundColor: Colors.black,
                              ),
                            );
                          },
                          height: 40,
                          width: 100.w,
                          color: MyColors().mainColor,
                          child: controller.processingOrder
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    MyText(
                                      text: 'Processing Order',
                                      size: 16,
                                      weight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ],
                                )
                              : const MyText(
                                  text: 'Process Order',
                                  size: 16,
                                  weight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                        )
                      : (isPending == false)
                          ? MyButton(
                              disabled: controller.finishingOrder,
                              buttonFunction: () async {
                                await controller.finishOrder(order, products);
                                Get.back();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 20,
                                    ),
                                    content: const Row(
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: Colors.green,
                                          size: 24,
                                        ),
                                        SizedBox(width: 8),
                                        MyText(
                                          text:
                                              'Order is moved to Finished Orders.',
                                          size: 16,
                                          weight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    duration: const Duration(seconds: 3),
                                    backgroundColor: Colors.black,
                                  ),
                                );
                              },
                              height: 40,
                              width: 100.w,
                              color: MyColors().mainColor,
                              child: controller.finishingOrder
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        MyText(
                                          text: 'Finishing Order',
                                          size: 16,
                                          weight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      ],
                                    )
                                  : const MyText(
                                      text: 'Finish Order',
                                      size: 16,
                                      weight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                            )
                          : Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
