import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myphone_admin/Controllers/home_controller.dart';
import 'package:myphone_admin/Widgets/app_bar.dart';
import 'package:myphone_admin/Widgets/button.dart';
import 'package:myphone_admin/Widgets/text.dart';
import 'package:myphone_admin/colors.dart';
import 'package:sizer/sizer.dart';

class ProductImage extends StatelessWidget {
  final String? image;
  final bool? isEditingProduct;
  const ProductImage({
    super.key,
    this.image = '',
    this.isEditingProduct = false,
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
              title: 'Product Image',
              leadingExists: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: image!.isEmpty
                            ? Border.all(color: Colors.black, width: 1)
                            : controller.image == null ? null : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: controller.image != null
                            ? Image.file(controller.image!, fit: BoxFit.cover)
                            : image!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: image!,
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
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 48,
                                      color: Colors.black,
                                    ),
                                  ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    MyButton(
                      disabled:
                          isEditingProduct != null && isEditingProduct == true
                              ? !controller.editingProduct
                              : false,
                      buttonFunction: controller.pickImage,
                      height: 40,
                      width: 100.w,
                      color: MyColors().mainColor,
                      child:
                          controller.image != null || isEditingProduct == true
                              ? const MyText(
                                  text: 'Change Image',
                                  size: 16,
                                  weight: FontWeight.normal,
                                  color: Colors.white,
                                )
                              : const MyText(
                                  text: 'Add Image',
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
        );
      },
    );
  }
}
