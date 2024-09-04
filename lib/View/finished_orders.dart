import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/home_controller.dart';
import '../Widgets/app_bar.dart';
import '../Widgets/page_entrance.dart';
import '../Widgets/text.dart';
import '../colors.dart';
import '../common_functions.dart';
import 'order_view.dart';

class FinishedOrders extends StatelessWidget {
  const FinishedOrders({
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
                title: 'Finished Orders',
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
                    (controller.finishedOrders.isNotEmpty) ? true : false,
                actionFunction: () {
                  if (controller.editingOrders) {
                    CommonFunctions().showDialogue(
                      false,
                      '',
                      () {
                        controller.deleteOrder('finished');
                        Get.back();
                      },
                      null,
                      'Deleted finished orders will be lost. Continue?',
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
              body: (controller.fetchingFinishedOrders)
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
                  : (controller.finishedOrders.isEmpty)
                      ? const Center(
                          child: MyText(
                            text: "There are no finished orders.",
                            size: 16,
                            weight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListView.builder(
                            itemCount: controller.finishedOrders.length,
                            itemBuilder: (BuildContext context, int index) {
                              return PageEntrance(
                                name: controller
                                    .finishedOrders[index].recipientFullName!,
                                color: controller.ordersToBeDeleted.contains(
                                    controller
                                        .finishedOrders[index].orderId!)
                                    ? MyColors().mainColor
                                    : Colors.white,
                                textColor: controller.ordersToBeDeleted
                                    .contains(controller
                                    .finishedOrders[index].orderId!)
                                    ? Colors.white
                                    : Colors.black,
                                iconColor: controller.ordersToBeDeleted
                                    .contains(controller
                                    .finishedOrders[index].orderId!)
                                    ? Colors.white
                                    : MyColors().mainColor,
                                order: controller.finishedOrders[index],
                                function: () {
                                  if (controller.editingOrders) {
                                    controller.selectOrder(controller
                                        .finishedOrders[index].orderId!);
                                  } else {
                                    Get.to(
                                          () => OrderView(
                                        order: controller.finishedOrders[index],
                                        products: controller
                                            .finishedOrdersProducts[index],
                                        isPending: null,
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
