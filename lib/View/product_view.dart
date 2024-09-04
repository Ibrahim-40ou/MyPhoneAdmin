import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../Controllers/home_controller.dart';
import '../Models/product.dart';
import '../Widgets/app_bar.dart';
import '../Widgets/button.dart';
import '../Widgets/text.dart';
import '../colors.dart';
import 'edit_product.dart';

class ProductView extends StatelessWidget {
  final Product product;
  const ProductView({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: MyAppBar(
              title: product.name!,
              leadingExists: true,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 33.3.h,
                  width: 100.w,
                  child: CachedNetworkImage(
                    imageUrl: product.image!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: MyColors().myBlue,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: MyColors().myRed,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: (product.memory != null)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 50,
                              width: (100.w - 52) / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: MyColors().secondaryColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const MyText(
                                    text: 'Color',
                                    size: 16,
                                    weight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  Container(
                                    height: 25,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: (100.w - 52) / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: MyColors().secondaryColor,
                              ),
                              child: Center(
                                child: MyText(
                                  text: product.memory!,
                                  size: 16,
                                  weight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Container(
                            height: 50,
                            width: (100.w - 52) / 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: MyColors().secondaryColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const MyText(
                                  text: 'Color',
                                  size: 16,
                                  weight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                Container(
                                  height: 25,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      child: MyText(
                        text: product.specifications!,
                        size: 16,
                        weight: FontWeight.normal,
                        color: Colors.black,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 10.h,
                  width: 100.w,
                  color: MyColors().secondaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: 'Price',
                            size: 22,
                            weight: FontWeight.bold,
                            color: MyColors().mainColor,
                          ),
                          MyText(
                            text: '\$${product.price}',
                            size: 18,
                            weight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      MyButton(
                        buttonFunction: () {
                          controller.insertData(product);
                          Get.to(
                            () => EditProduct(
                              product: product,
                            ),
                          );

                        },
                        height: 50,
                        width: 40.w,
                        color: MyColors().mainColor,
                        child: const MyText(
                          text: 'Edit',
                          size: 16,
                          weight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
