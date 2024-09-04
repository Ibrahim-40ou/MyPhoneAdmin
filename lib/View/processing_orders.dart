import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/home_controller.dart';
import '../Widgets/app_bar.dart';
import '../Widgets/page_entrance.dart';
import '../Widgets/text.dart';
import '../colors.dart';
import '../common_functions.dart';
import 'order_view.dart';

class ProcessingOrders extends StatelessWidget {
  const ProcessingOrders({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            if (controller.editingOrders) {
              CommonFunctions().showDialogue(
                false,
                '',
                    () {
                  controller.cancelOrdersEdit();
                  Get.back();
                },
                null,
                'Are you sure you want to cancel editing? Selected orders will be unselected.',
              );
            } else {
              Get.back();
            }
            return true;
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: MyAppBar(
                title: 'Processing Orders',
                leadingExists: true,
                leadingFunction: () {
                  if (controller.editingOrders) {
                    CommonFunctions().showDialogue(
                      false,
                      '',
                          () {
                        controller.cancelOrdersEdit();
                        Get.back();
                      },
                      null,
                      'Are you sure you want to cancel editing? Selected orders will be unselected.',
                    );
                  } else {
                    Get.back();
                  }
                },
                actionExists:
                (controller.processingOrders.isNotEmpty) ? true : false,
                actionFunction: () {
                  if (controller.editingOrders) {
                    CommonFunctions().showDialogue(
                      false,
                      '',
                          () {
                        controller.deleteOrder('processing');
                        Get.back();
                      },
                      null,
                      'Deleting processing orders will not get them processed and they will be lost. Continue?',
                    );
                  } else {
                    controller.editOrders();
                  }
                },
                icon: controller.editingOrders
                    ? const Icon(
                  Icons.delete,
                  size: 24,
                  color: Colors.red,
                )
                    : const Icon(
                  Icons.edit,
                  size: 24,
                  color: Colors.black,
                ),
              ),
              body: (controller.fetchingProcessingOrders)
                  ? const Center(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : (controller.processingOrders.isEmpty)
                      ? const Center(
                          child: MyText(
                            text: "You have no orders to process.",
                            size: 16,
                            weight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListView.builder(
                            itemCount: controller.processingOrders.length,
                            itemBuilder: (BuildContext context, int index) {
                              return PageEntrance(
                                name: controller
                                    .processingOrders[index].recipientFullName!,
                                color: controller.ordersToBeDeleted.contains(
                                    controller
                                        .processingOrders[index].orderId!)
                                    ? MyColors().mainColor
                                    : Colors.white,
                                textColor: controller.ordersToBeDeleted
                                    .contains(controller
                                    .processingOrders[index].orderId!)
                                    ? Colors.white
                                    : Colors.black,
                                iconColor: controller.ordersToBeDeleted
                                    .contains(controller
                                    .processingOrders[index].orderId!)
                                    ? Colors.white
                                    : MyColors().mainColor,
                                order: controller.processingOrders[index],
                                function: () {
                                  if (controller.editingOrders) {
                                    controller.selectOrder(controller
                                        .processingOrders[index].orderId!);
                                  } else {
                                    Get.to(
                                          () => OrderView(
                                        order: controller.processingOrders[index],
                                        products: controller
                                            .processingOrdersProducts[index],
                                        isPending: false,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
            ),
          ),
        );
      },
    );
  }
}
