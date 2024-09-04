import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myphone_admin/Controllers/home_controller.dart';
import 'package:myphone_admin/Widgets/app_bar.dart';
import 'package:myphone_admin/Widgets/button.dart';
import 'package:myphone_admin/Widgets/dropdown.dart';
import 'package:myphone_admin/Widgets/text.dart';
import 'package:myphone_admin/Widgets/text_form_field.dart';
import 'package:myphone_admin/colors.dart';
import 'package:sizer/sizer.dart';

import '../product_image.dart';

class Add extends StatelessWidget {
  const Add({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: const MyAppBar(
              title: 'Add a Product',
              leadingExists: false,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.addFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      MyDropdown(
                        width: 100.w,
                        hintText: 'Product Type',
                        value: controller.productType,
                        items: controller.productTypes,
                        changeValue: controller.selectProductType,
                        icon: const Icon(
                          Icons.question_mark,
                          size: 24,
                          color: Colors.black,
                        ),
                        validatorFunction: controller.validateField,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyDropdown(
                            width: (100.w - 42) / 2,
                            hintText: 'Category',
                            value: controller.productCategory,
                            items: controller.availableCategories,
                            changeValue: controller.changeCategory,
                            icon: const Icon(
                              Icons.menu,
                              size: 24,
                              color: Colors.black,
                            ),
                            validatorFunction: controller.validateField,
                          ),
                          MyDropdown(
                            width: (100.w - 42) / 2,
                            hintText: 'Brand',
                            value: controller.productBrand,
                            items: controller.availableBrands,
                            changeValue: controller.changeBrand,
                            icon: const Icon(
                              CupertinoIcons.tag_fill,
                              color: Colors.black,
                              size: 24,
                            ),
                            validatorFunction: controller.validateField,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      MyField(
                        width: 100.w,
                        controller: controller.productNameController,
                        hintText: 'Product Name',
                        isPassword: false,
                        isLast: false,
                        isName: true,
                        type: TextInputType.text,
                        prefixIcon: const Icon(
                          Icons.label,
                          color: Colors.black,
                          size: 24,
                        ),
                        validatorFunction: controller.validateField,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyField(
                            width: (100.w - 42) / 2,
                            controller: controller.productColorController,
                            hintText: 'Color',
                            isPassword: false,
                            isLast: false,
                            isName: true,
                            type: TextInputType.text,
                            prefixIcon: const Icon(
                              Icons.color_lens,
                              color: Colors.black,
                              size: 24,
                            ),
                            validatorFunction: controller.validateField,
                          ),
                          MyField(
                            width: (100.w - 42) / 2,
                            controller: controller.productHexColorController,
                            hintText: 'Color in Hex',
                            isPassword: false,
                            isLast: false,
                            isName: false,
                            type: TextInputType.text,
                            prefixIcon: const Icon(
                              Icons.numbers,
                              color: Colors.black,
                              size: 24,
                            ),
                            validatorFunction: controller.validateHexColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyField(
                            enabled: controller.productCategory == 'phones' ||
                                controller.productCategory == 'laptops' ||
                                controller.productCategory == 'watches' ||
                                controller.productCategory == 'bands',
                            width: (100.w - 42) / 2,
                            controller: controller.productMemoryController,
                            hintText: 'Capacity/RAM',
                            isPassword: false,
                            isLast: false,
                            isName: false,
                            type: TextInputType.text,
                            prefixIcon: const Icon(
                              Icons.memory,
                              size: 24,
                              color: Colors.black,
                            ),
                            validatorFunction: controller.validateMemory,
                          ),
                          MyField(
                            enabled: controller.productCategory == 'chargers',
                            width: (100.w - 42) / 2,
                            controller: controller.productWattageController,
                            hintText: 'Wattage',
                            isPassword: false,
                            isLast: false,
                            isName: false,
                            type: TextInputType.number,
                            prefixIcon: const Icon(
                              Icons.power,
                              size: 24,
                              color: Colors.black,
                            ),
                            validatorFunction: controller.validatePositiveValue,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyField(
                            width: (100.w - 42) / 2,
                            controller: controller.productPriceController,
                            hintText: 'Price',
                            isPassword: false,
                            isLast: false,
                            isName: false,
                            type: TextInputType.number,
                            prefixIcon: const Icon(
                              CupertinoIcons.money_dollar,
                              size: 24,
                              color: Colors.black,
                            ),
                            validatorFunction: controller.validatePositiveValue,
                          ),
                          MyField(
                            width: (100.w - 42) / 2,
                            controller: controller.productStockController,
                            hintText: 'Stock',
                            isPassword: false,
                            isLast: false,
                            isName: false,
                            type: TextInputType.number,
                            prefixIcon: const Icon(
                              Icons.numbers,
                              size: 24,
                              color: Colors.black,
                            ),
                            validatorFunction: controller.validatePositiveValue,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      MyField(
                        maxLines: 5,
                        width: 100.w,
                        controller: controller.productSpecificationsController,
                        hintText: 'Specifications',
                        isPassword: false,
                        isLast: true,
                        isName: false,
                        type: TextInputType.text,
                        prefixIcon: const Icon(
                          Icons.description,
                          color: Colors.black,
                          size: 24,
                        ),
                        validatorFunction: controller.validateField,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyButton(
                            buttonFunction: () {
                              Get.to(
                                () => const ProductImage(),
                              );
                            },
                            height: 40,
                            width: 100.w - 102,
                            color: MyColors().mainColor,
                            child: const MyText(
                              text: 'View Product Image',
                              size: 16,
                              weight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                          (controller.image == null)
                              ? MyButton(
                                  buttonFunction: controller.pickImage,
                                  height: 40,
                                  width: 60,
                                  color: MyColors().mainColor,
                                  child: const Icon(
                                    Icons.add,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                )
                              : SizedBox(
                                  height: 40,
                                  width: 60,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      controller.image!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      controller.imageExists
                          ? Container()
                          : Column(
                              children: [
                                const SizedBox(height: 5),
                                MyText(
                                  text: 'Enter an image.',
                                  size: 14,
                                  weight: FontWeight.normal,
                                  color: MyColors().myRed,
                                ),
                              ],
                            ),
                      const SizedBox(height: 40),
                      MyButton(
                        buttonFunction: () async {
                          controller.validateImage();
                          if (controller.addFormKey.currentState!.validate() &&
                              controller.imageExists) {
                            await controller.addProduct(
                              controller.productCategory!.toLowerCase(),
                              controller.productBrand!.toLowerCase(),
                            );
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
                                      text: 'Product is successfully added.',
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
                          }
                        },
                        disabled: controller.addingProduct,
                        height: 40,
                        width: 100.w,
                        color: MyColors().mainColor,
                        child: controller.addingProduct
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
                                    text: 'Adding Product',
                                    size: 16,
                                    weight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ],
                              )
                            : const MyText(
                                text: 'Add Product',
                                size: 16,
                                weight: FontWeight.normal,
                                color: Colors.white,
                              ),
                      ),
                      const SizedBox(height: 20),
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
