import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myphone_admin/Controllers/home_controller.dart';
import 'package:myphone_admin/View/product_image.dart';
import 'package:myphone_admin/Widgets/app_bar.dart';
import 'package:sizer/sizer.dart';

import '../Models/product.dart';
import '../Widgets/button.dart';
import '../Widgets/dropdown.dart';
import '../Widgets/text.dart';
import '../Widgets/text_form_field.dart';
import '../colors.dart';
import '../common_functions.dart';

class EditProduct extends StatelessWidget {
  final Product product;
  const EditProduct({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            if (controller.editingProduct) {
              CommonFunctions().showDialogue(
                false,
                '',
                () {
                  controller.cancelEditingProduct(product);
                  controller.clearAdd();
                  Get.back();
                  Get.back();
                },
                null,
                'Are you sure you want to exit the page? Changes made will not be applied.',
              );
            } else {
              controller.clearAdd();
              Get.back();
            }
            return true;
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: MyAppBar(
                title: 'Edit Product',
                leadingExists: true,
                leadingFunction: () {
                  if (controller.editingProduct) {
                    CommonFunctions().showDialogue(
                      false,
                      '',
                      () {
                        controller.cancelEditingProduct(product);
                        controller.clearAdd();
                        Get.back();
                        Get.back();
                      },
                      null,
                      'Are you sure you want to exit the page? Changes made will not be applied.',
                    );
                  } else {
                    Get.back();
                    controller.clearAdd();
                  }
                },
                actionExists: true,
                icon: Icon(
                  Icons.delete,
                  size: 24,
                  color: MyColors().myRed,
                ),
                actionFunction: () {
                  CommonFunctions().showDialogue(
                    false,
                    '',
                    () async {
                      await controller.deleteProduct(
                        product.category!.toLowerCase(),
                        product.brand!.toLowerCase(),
                        product,
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
                                text: 'Product is successfully deleted.',
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
                      controller.clearAdd();
                      Get.back();
                      Get.back();
                      Get.back();
                    },
                    null,
                    'Are you sure you want to delete this product? It will be permanently deleted',
                  );
                },
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyDropdown(
                              enabled: controller.editingProduct,
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
                              enabled: controller.editingProduct,
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
                          enabled: controller.editingProduct,
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
                              enabled: controller.editingProduct,
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
                              enabled: controller.editingProduct,
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
                              enabled: controller.editingProduct == false
                                  ? false
                                  : controller.productCategory == 'phones' ||
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
                              enabled: controller.editingProduct == false
                                  ? false
                                  : controller.productCategory == 'chargers',
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
                              validatorFunction:
                                  controller.validatePositiveValue,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyField(
                              enabled: controller.editingProduct,
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
                              validatorFunction:
                                  controller.validatePositiveValue,
                            ),
                            MyField(
                              enabled: controller.editingProduct,
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
                              validatorFunction:
                                  controller.validatePositiveValue,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        MyField(
                          enabled: controller.editingProduct,
                          width: 100.w,
                          controller:
                              controller.productSpecificationsController,
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
                                  () => ProductImage(
                                    image: product.image,
                                    isEditingProduct: true,
                                  ),
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
                                ? SizedBox(
                                    height: 40,
                                    width: 60,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
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
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                          Icons.error,
                                          color: MyColors().myRed,
                                        ),
                                      ),
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
                        (controller.editingProduct)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyButton(
                                    disabled: controller.savingChanges,
                                    buttonFunction: () async {
                                      await controller.saveChanges(
                                        product.category!.toLowerCase(),
                                        product.brand!.toLowerCase(),
                                        product,
                                      );
                                    },
                                    height: 40,
                                    width: 100.w,
                                    color: MyColors().mainColor,
                                    child: controller.savingChanges
                                        ? const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 24,
                                                width: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              MyText(
                                                text: 'Saving Changes',
                                                size: 16,
                                                weight: FontWeight.normal,
                                                color: Colors.white,
                                              ),
                                            ],
                                          )
                                        : const MyText(
                                            text: 'Save Changes',
                                            size: 16,
                                            weight: FontWeight.normal,
                                            color: Colors.white,
                                          ),
                                  ),
                                  const SizedBox(height: 20),
                                  MyButton(
                                    buttonFunction: () {
                                      CommonFunctions().showDialogue(
                                        false,
                                        '',
                                        () {
                                          controller
                                              .cancelEditingProduct(product);
                                          Get.back();
                                        },
                                        null,
                                        'Are you sure you want to cancel editing? Changes made will not be applied.',
                                      );
                                    },
                                    height: 40,
                                    width: 100.w,
                                    color: MyColors().myRed,
                                    child: const MyText(
                                      text: 'Cancel',
                                      size: 16,
                                      weight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              )
                            : MyButton(
                                buttonFunction: controller.startEditingProduct,
                                height: 40,
                                width: 100.w,
                                color: MyColors().mainColor,
                                child: const MyText(
                                  text: 'Edit Product',
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
          ),
        );
      },
    );
  }
}
