import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myphone_admin/common_functions.dart';
import '../Models/order.dart';
import '../Models/product.dart';
import '../View/HomeView/add.dart';
import '../View/HomeView/main.dart';
import '../View/HomeView/settings.dart';
import '../Widgets/text.dart';
import '../colors.dart';
import '../main.dart';

class HomeController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    fetchOffers();
    fetchBestSelling();
    await fetchPendingOrders();
    await fetchProcessingOrders();
    await fetchFinishedOrders();
    await fetchAllProducts();
  }

  TextEditingController searchController = TextEditingController();
  TextEditingController ramController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();

  final addFormKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productColorController = TextEditingController();
  TextEditingController productHexColorController = TextEditingController();
  TextEditingController productMemoryController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productStockController = TextEditingController();
  TextEditingController productImageController = TextEditingController();
  TextEditingController productSpecificationsController =
      TextEditingController();
  TextEditingController productWattageController = TextEditingController();

  PageController pageController = PageController();

  int currentIndex = 0;
  void changePage(int index) {
    currentIndex = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 1),
      curve: Curves.linear,
    );
    update();
  }

  List<BottomNavigationBarItem> navigationBarItems = [
    BottomNavigationBarItem(
      icon: const Icon(Icons.home_outlined),
      activeIcon: const Icon(Icons.home),
      label: 'home'.tr,
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.add_outlined),
      activeIcon: const Icon(Icons.add),
      label: 'add'.tr,
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.settings_outlined),
      activeIcon: const Icon(Icons.settings),
      label: 'settings'.tr,
    ),
  ];

  List<Widget> pageViewItems = [
    const Main(),
    const Add(),
    const AppSettings(),
  ];

  bool isLoading = false;
  String errorText = '';
  bool signOutError = false;
  void exitDialogue() {
    signOutError = false;
    errorText = '';
    update();
  }

  void signOut() async {
    try {
      isLoading = true;
      update();
      await FirebaseAuth.instance.signOut();
      isLoading = false;
      update();
      loginCheck!.clear();
      Get.offAllNamed('/');
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      update();
      print(e.code);
    }
  }

  Map<String, List<Product>> fetchedProducts = {
    'phones': [],
    'laptops': [],
    'headphones': [],
    'watches': [],
    'bands': [],
    'chargers': [],
    'cases': [],
    'others': [],
  };
  Map<String, Set<String>> fetchedBrands = {
    'phones': {},
    'laptops': {},
    'headphones': {},
    'watches': {},
    'bands': {},
    'chargers': {},
    'cases': {},
    'others': {},
  };

  bool fetchingBrandProducts = false;
  Future fetchBrandProducts(
    String collectionPath,
    String fieldName,
    String fieldValue,
  ) async {
    try {
      if (fetchedBrands[collectionPath]!.contains(fieldValue)) {
        return;
      }
      fetchingBrandProducts = true;
      update();
      final CollectionReference categoryRef =
          FirebaseFirestore.instance.collection(collectionPath);
      final QuerySnapshot brandSnapshot =
          await categoryRef.where(fieldName, isEqualTo: fieldValue).get();
      if (brandSnapshot.docs.isNotEmpty) {
        DocumentSnapshot brandDocument = brandSnapshot.docs.first;
        CollectionReference productsCollection =
            brandDocument.reference.collection('products');
        QuerySnapshot productsSnapshot = await productsCollection.get();
        for (var doc in productsSnapshot.docs) {
          fetchedProducts[collectionPath]!
              .add(Product.fromJson(doc.data() as Map<String, dynamic>));
        }
      }
      fetchedBrands[collectionPath]!.add(fieldValue);
      fetchingBrandProducts = false;
      update();
    } on FirebaseException catch (e) {
      fetchingBrandProducts = false;
      update();
      print(e.code);
    }
  }

  List<Product> offers = [];
  bool fetchingOffers = false;
  Future fetchOffers() async {
    try {
      fetchingOffers = true;
      update();

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('offers').get();
      for (var product in querySnapshot.docs) {
        offers.add(
          Product.fromJson(
            product.data() as Map<String, dynamic>,
          ),
        );
      }

      fetchingOffers = false;
      update();
    } on FirebaseException catch (e) {
      fetchingOffers = false;
      update();
      print(e.code);
    }
  }

  List<Product> bestSelling = [];
  bool fetchingBestSelling = false;
  Future fetchBestSelling() async {
    fetchingBestSelling = true;
    update();
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('bestSelling').get();
      for (var document in querySnapshot.docs) {
        bestSelling
            .add(Product.fromJson(document.data() as Map<String, dynamic>));
      }
      fetchingBestSelling = false;
      update();
    } on FirebaseException catch (e) {
      fetchingBestSelling = false;
      update();
      print(e.code);
    }
  }

  List<Product> allProducts = [];
  bool fetchingAllProducts = false;
  Future fetchAllProducts() async {
    try {
      fetchingAllProducts = true;
      update();
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('allProducts').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          allProducts.add(
            Product.fromJson(doc.data() as Map<String, dynamic>),
          );
        }
      }
      fetchingAllProducts = false;
      update();
    } on FirebaseException catch (e) {
      fetchingAllProducts = false;
      update();
      print(e.code);
    }
  }

  static Widget _buildTextWidget(String text) {
    return MyText(
      text: text,
      size: 16,
      weight: FontWeight.normal,
      color: Colors.black,
      overflow: TextOverflow.fade,
    );
  }

  String? category;
  List<DropdownMenuItem<String>> categories = [
    DropdownMenuItem(
      value: 'all',
      child: _buildTextWidget('All Categories'),
    ),
    DropdownMenuItem(
      value: 'phones',
      child: _buildTextWidget('Phones'),
    ),
    DropdownMenuItem(
      value: 'laptops',
      child: _buildTextWidget('Laptops'),
    ),
    DropdownMenuItem(
      value: 'headphones',
      child: _buildTextWidget('Headphones'),
    ),
    DropdownMenuItem(
      value: 'watches',
      child: _buildTextWidget('Smart Watches'),
    ),
    DropdownMenuItem(
      value: 'bands',
      child: _buildTextWidget('Smart Bands'),
    ),
    DropdownMenuItem(
      value: 'chargers',
      child: _buildTextWidget('Chargers And Cables'),
    ),
    DropdownMenuItem(
      value: 'cases',
      child: _buildTextWidget('Cases'),
    ),
    DropdownMenuItem(
      value: 'others',
      child: _buildTextWidget('Others'),
    ),
  ];
  void selectCategory(String? selectedCategory) {
    category = selectedCategory!;
    update();
  }

  String? brand;
  List<DropdownMenuItem<String>> brands = [
    DropdownMenuItem(
      value: 'all',
      child: _buildTextWidget('All Brands'),
    ),
    DropdownMenuItem(
      value: 'apple',
      child: _buildTextWidget('Apple'),
    ),
    DropdownMenuItem(
      value: 'samsung',
      child: _buildTextWidget('Samsung'),
    ),
    DropdownMenuItem(
      value: 'huawei',
      child: _buildTextWidget('Huawei'),
    ),
    DropdownMenuItem(
      value: 'google',
      child: _buildTextWidget('Google'),
    ),
    DropdownMenuItem(
      value: 'xiaomi',
      child: _buildTextWidget('Xiaomi'),
    ),
    DropdownMenuItem(
      value: 'asus',
      child: _buildTextWidget('Asus'),
    ),
    DropdownMenuItem(
      value: 'hp',
      child: _buildTextWidget('Hp'),
    ),
    DropdownMenuItem(
      value: 'sony',
      child: _buildTextWidget('Sony'),
    ),
  ];
  void selectBrand(String? selectedBrand) {
    brand = selectedBrand!;
    update();
  }

  String? priceSort;
  List<DropdownMenuItem<String>> sortByPrice = [
    DropdownMenuItem(
      value: 'ascending',
      child: _buildTextWidget('Ascending: Lowest to Highest'),
    ),
    DropdownMenuItem(
      value: 'descending',
      child: _buildTextWidget('Descending: Highest to Lowest'),
    ),
  ];
  void selectPriceSort(String? selectedPriceSort) {
    priceSort = selectedPriceSort;
    update();
  }

  List<Product> searchResult = [];
  bool searchingProducts = false;
  void searchProducts() {
    searchResult.clear();
    searchingProducts = true;
    update();

    bool hasFilters = category != null ||
        brand != null ||
        minPriceController.text.isNotEmpty ||
        maxPriceController.text.isNotEmpty ||
        capacityController.text.isNotEmpty ||
        ramController.text.isNotEmpty;

    if (searchController.text.isEmpty && hasFilters == false) {
      searchResult.clear();
      searchingProducts = false;
      update();
      return;
    }

    for (Product product in allProducts) {
      bool matchesSearchQuery = searchController.text.isEmpty ||
          product.name!
              .toLowerCase()
              .contains(searchController.text.toLowerCase());
      bool matchesCategory =
          category == null || product.category == category || category == 'all';
      bool matchesBrand = brand == null ||
          product.brand!.toLowerCase() == brand ||
          brand == 'all';
      bool matchesCapacity = capacityController.text.isEmpty ||
          (product.memory != null &&
              product.memory!.split('/').first == capacityController.text);
      bool matchesRam = ramController.text.isEmpty ||
          (product.memory != null &&
              product.memory!.split('/').last == ramController.text);
      bool matchesPrice = (minPriceController.text.isEmpty &&
              maxPriceController.text.isEmpty) ||
          (minPriceController.text.isNotEmpty &&
              product.price! >= double.parse(minPriceController.text) &&
              (maxPriceController.text.isEmpty ||
                  product.price! <= double.parse(maxPriceController.text))) ||
          (maxPriceController.text.isNotEmpty &&
              product.price! <= double.parse(maxPriceController.text) &&
              (minPriceController.text.isEmpty ||
                  product.price! >= double.parse(minPriceController.text)));

      if (searchController.text.isEmpty && hasFilters == true) {
        if (matchesCategory &&
            matchesBrand &&
            matchesCapacity &&
            matchesRam &&
            matchesPrice) {
          searchResult.add(product);
        }
      } else if (searchController.text.isNotEmpty && hasFilters == true) {
        if (matchesSearchQuery &&
            matchesCategory &&
            matchesBrand &&
            matchesCapacity &&
            matchesRam &&
            matchesPrice) {
          searchResult.add(product);
        }
      } else if (searchController.text.isNotEmpty && hasFilters == false) {
        if (matchesSearchQuery) {
          searchResult.add(product);
        }
      }
    }

    if (priceSort != null) {
      if (priceSort == 'ascending') {
        searchResult.sort(
          (a, b) {
            double priceA = a.price!;
            double priceB = b.price!;
            return priceA.compareTo(priceB);
          },
        );
      } else if (priceSort == 'descending') {
        searchResult.sort(
          (a, b) {
            double priceA = a.price!;
            double priceB = b.price!;
            return priceB.compareTo(priceA);
          },
        );
      }
    }
    searchingProducts = false;
    update();
  }

  void clearSearch() {
    searchController.clear();
    category = null;
    brand = null;
    minPriceController.clear();
    maxPriceController.clear();
    capacityController.clear();
    ramController.clear();
    searchResult.clear();
    update();
    Get.back();
  }

  bool editingFilters = false;
  String? preEditCategory;
  String? preEditBrand;
  String? preEditMinPrice;
  String? preEditMaxPrice;
  String? preEditCapacity;
  String? preEditRam;
  void editFilters() {
    preEditCategory = category;
    preEditBrand = brand;
    preEditMinPrice = minPriceController.text;
    preEditMaxPrice = maxPriceController.text;
    preEditCapacity = capacityController.text;
    preEditRam = ramController.text;
    editingFilters = true;
    update();
  }

  void cancelEditingFilters() {
    category = preEditCategory;
    brand = preEditBrand;
    minPriceController.text = preEditMinPrice ?? '';
    maxPriceController.text = preEditMaxPrice ?? '';
    capacityController.text = preEditCapacity ?? '';
    ramController.text = preEditRam ?? '';
    editingFilters = false;
    update();
    Get.back();
  }

  void finishEditingFilters() {
    editingFilters = false;
    update();
  }

  void onLeaveFilters() {
    cancelEditingFilters();
    Get.back();
  }

  List<MyOrder> pendingOrders = [];
  List<List<Product>> pendingOrdersProducts = [];
  bool fetchingPendingOrders = false;
  Future fetchPendingOrders() async {
    try {
      fetchingPendingOrders = true;
      update();

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      pendingOrders.clear();
      pendingOrdersProducts.clear();

      for (var doc in querySnapshot.docs) {
        pendingOrders.add(MyOrder.fromJson(doc.data() as Map<String, dynamic>));

        QuerySnapshot productsSnapshot =
            await doc.reference.collection('products').get();

        List<Product> products = [];

        for (var productDoc in productsSnapshot.docs) {
          products
              .add(Product.fromJson(productDoc.data() as Map<String, dynamic>));
        }

        pendingOrdersProducts.add(products);
      }

      fetchingPendingOrders = false;
      update();
    } on FirebaseException catch (e) {
      fetchingPendingOrders = false;
      update();
      print(e.code);
    }
  }

  bool processingOrder = false;
  List<MyOrder> processingOrders = [];
  List<List<Product>> processingOrdersProducts = [];
  Future processOrder(MyOrder order, List<Product> products) async {
    try {
      final instance = FirebaseFirestore.instance;
      processingOrder = true;
      update();
      DocumentReference documentReference =
          instance.collection('processingOrders').doc(order.orderId!);
      await documentReference.set(order.toJson());
      await documentReference.update({'status': 'processing'});
      order.status = 'processing';
      processingOrders.add(order);
      for (int i = 0; i < products.length; i++) {
        documentReference
            .collection('products')
            .doc(products[i].productId!)
            .set(products[i].toJson());
      }
      processingOrdersProducts.add(products);
      QuerySnapshot querySnapshot = await instance
          .collection('orders')
          .doc(order.orderId!)
          .collection('products')
          .get();
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
      await instance.collection('orders').doc(order.orderId!).delete();
      pendingOrders.removeWhere((pending) => pending.orderId == order.orderId);
      pendingOrdersProducts.removeWhere((pending) => pending == products);
      processingOrder = false;
      update();
    } on FirebaseException catch (e) {
      processingOrder = false;
      update();
      print(e.code);
    }
  }

  bool fetchingProcessingOrders = false;
  Future fetchProcessingOrders() async {
    try {
      fetchingProcessingOrders = true;
      update();
      final instance = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot =
          await instance.collection('processingOrders').get();
      for (var doc in querySnapshot.docs) {
        processingOrders.add(
          MyOrder.fromJson(
            doc.data() as Map<String, dynamic>,
          ),
        );
        QuerySnapshot productsSnapshot =
            await doc.reference.collection('products').get();

        List<Product> products = [];

        for (var productDoc in productsSnapshot.docs) {
          products
              .add(Product.fromJson(productDoc.data() as Map<String, dynamic>));
        }

        processingOrdersProducts.add(products);
      }
      fetchingProcessingOrders = false;
      update();
    } on FirebaseException catch (e) {
      fetchingProcessingOrders = false;
      update();
      print(e.code);
    }
  }

  bool finishingOrder = false;
  List<MyOrder> finishedOrders = [];
  List<List<Product>> finishedOrdersProducts = [];
  Future finishOrder(MyOrder order, List<Product> products) async {
    try {
      final instance = FirebaseFirestore.instance;
      finishingOrder = true;
      update();

      DocumentReference documentReference =
          instance.collection('finishedOrders').doc(order.orderId!);
      await documentReference.set(order.toJson());
      await documentReference.update({'status': 'finished'});
      order.status = 'finished';
      finishedOrders.add(order);
      for (int i = 0; i < products.length; i++) {
        documentReference
            .collection('products')
            .doc(products[i].productId!)
            .set(products[i].toJson());
      }
      finishedOrdersProducts.add(products);
      QuerySnapshot querySnapshot = await instance
          .collection('processingOrders')
          .doc(order.orderId!)
          .collection('products')
          .get();
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
      await instance
          .collection('processingOrders')
          .doc(order.orderId!)
          .delete();
      processingOrders
          .removeWhere((pending) => pending.orderId == order.orderId);
      processingOrdersProducts.removeWhere((pending) => pending == products);
      finishingOrder = false;
      update();
    } on FirebaseException catch (e) {
      finishingOrder = false;
      update();
      print(e.code);
    }
  }

  bool fetchingFinishedOrders = false;

  Future fetchFinishedOrders() async {
    try {
      fetchingFinishedOrders = true;
      update();
      final instance = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot =
          await instance.collection('finishedOrders').get();
      for (var doc in querySnapshot.docs) {
        finishedOrders.add(
          MyOrder.fromJson(
            doc.data() as Map<String, dynamic>,
          ),
        );
        QuerySnapshot productsSnapshot =
            await doc.reference.collection('products').get();

        List<Product> products = [];

        for (var productDoc in productsSnapshot.docs) {
          products
              .add(Product.fromJson(productDoc.data() as Map<String, dynamic>));
        }

        finishedOrdersProducts.add(products);
      }
      fetchingFinishedOrders = false;
      update();
    } on FirebaseException catch (e) {
      fetchingFinishedOrders = false;
      update();
      print(e.code);
    }
  }

  bool editingOrders = false;
  void editOrders() {
    editingOrders = true;
    update();
  }

  List<String> ordersToBeDeleted = [];
  void selectOrder(String id) {
    if (ordersToBeDeleted.contains(id)) {
      ordersToBeDeleted.remove(id);
    } else {
      ordersToBeDeleted.add(id);
    }
    update();
  }

  void cancelOrdersEdit() {
    editingOrders = false;
    ordersToBeDeleted.clear();
    update();
  }

  Future deleteOrder(String key) async {
    if (key == 'pending') {
      for (String id in ordersToBeDeleted) {
        await FirebaseFirestore.instance.collection('orders').doc(id).delete();
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .doc(id)
            .collection('products')
            .get();
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
        pendingOrdersProducts
            .removeAt(pendingOrders.indexWhere((order) => order.orderId == id));
        pendingOrders.removeWhere((order) => order.orderId == id);
      }
    } else if (key == 'processing') {
      for (String id in ordersToBeDeleted) {
        await FirebaseFirestore.instance
            .collection('processingOrders')
            .doc(id)
            .delete();
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('processingOrders')
            .doc(id)
            .collection('products')
            .get();
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
        processingOrdersProducts.removeAt(
            processingOrders.indexWhere((order) => order.orderId == id));
        processingOrders.removeWhere((order) => order.orderId == id);
      }
    } else {
      for (String id in ordersToBeDeleted) {
        await FirebaseFirestore.instance
            .collection('finishedOrders')
            .doc(id)
            .delete();
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('finishedOrders')
            .doc(id)
            .collection('products')
            .get();
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
        finishedOrdersProducts.removeAt(
            finishedOrders.indexWhere((order) => order.orderId == id));
        finishedOrders.removeWhere((order) => order.orderId == id);
      }
    }

    cancelOrdersEdit();
  }

  String? productCategory;
  List<DropdownMenuItem<String>> availableCategories = [
    DropdownMenuItem(
      value: 'phones',
      child: _buildTextWidget('Phones'),
    ),
    DropdownMenuItem(
      value: 'laptops',
      child: _buildTextWidget('Laptops'),
    ),
    DropdownMenuItem(
      value: 'headphones',
      child: _buildTextWidget('Headphones'),
    ),
    DropdownMenuItem(
      value: 'watches',
      child: _buildTextWidget('Smart Watches'),
    ),
    DropdownMenuItem(
      value: 'bands',
      child: _buildTextWidget('Smart Bands'),
    ),
    DropdownMenuItem(
      value: 'chargers',
      child: _buildTextWidget('Chargers And Cables'),
    ),
    DropdownMenuItem(
      value: 'cases',
      child: _buildTextWidget('Cases'),
    ),
    DropdownMenuItem(
      value: 'others',
      child: _buildTextWidget('Others'),
    ),
  ];
  void changeCategory(String? selectedCategory) {
    productCategory = selectedCategory!;
    update();
  }

  String? productBrand;
  List<DropdownMenuItem<String>> availableBrands = [
    DropdownMenuItem(
      value: 'apple',
      child: _buildTextWidget('Apple'),
    ),
    DropdownMenuItem(
      value: 'samsung',
      child: _buildTextWidget('Samsung'),
    ),
    DropdownMenuItem(
      value: 'huawei',
      child: _buildTextWidget('Huawei'),
    ),
    DropdownMenuItem(
      value: 'google',
      child: _buildTextWidget('Google'),
    ),
    DropdownMenuItem(
      value: 'xiaomi',
      child: _buildTextWidget('Xiaomi'),
    ),
    DropdownMenuItem(
      value: 'asus',
      child: _buildTextWidget('Asus'),
    ),
    DropdownMenuItem(
      value: 'hp',
      child: _buildTextWidget('Hp'),
    ),
    DropdownMenuItem(
      value: 'sony',
      child: _buildTextWidget('Sony'),
    ),
  ];
  void changeBrand(String? selectedBrand) {
    productBrand = selectedBrand!;
    update();
  }

  File? image;
  String? downloadUrl;
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    validateImage();
    update();
  }

  Future<void> uploadImage() async {
    if (image == null) return;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    try {
      final uploadTask = await storageRef.putFile(image!);
      downloadUrl = await uploadTask.ref.getDownloadURL();
      update();
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }

  String? validateField(String? value) =>
      (value == null || value.isEmpty) ? 'enter a valid value.'.tr : null;

  String? validateHexColor(String? value) {
    if (value == null || value.isEmpty) {
      return 'enter a valid value.'.tr;
    }

    final RegExp regex = RegExp(r'^[0-9A-Fa-f]+$');
    if (!regex.hasMatch(value) || value.length > 6 || value.length < 6) {
      return 'Invalid hex color format.';
    }

    return null;
  }

  String? validateMemory(String? value) {
    if (value == null || value.isEmpty) {
      return 'enter a valid value.'.tr;
    }

    final RegExp regex = RegExp(r'^\d+/\d+$');
    if (!regex.hasMatch(value)) {
      return 'Invalid format. Use x/x (e.g., 256/8).';
    }

    return null;
  }

  String? validatePositiveValue(String? value) {
    if (value == null || value.isEmpty || double.parse(value) <= 0) {
      return 'enter a valid value.'.tr;
    }
    return null;
  }

  bool imageExists = true;
  void validateImage() {
    if (image != null) {
      imageExists = true;
    } else {
      imageExists = false;
    }
    update();
  }

  String? productType;
  List<DropdownMenuItem<String>> productTypes = [
    DropdownMenuItem(
      value: 'best',
      child: _buildTextWidget('Best Selling Product'),
    ),
    DropdownMenuItem(
      value: 'offer',
      child: _buildTextWidget('Offer'),
    ),
    DropdownMenuItem(
      value: 'regular',
      child: _buildTextWidget('Regular Product'),
    ),
  ];

  void selectProductType(String? type) {
    productType = type;
    update();
  }

  bool addingProduct = false;
  Future addProduct(String category, String brand) async {
    try {
      addingProduct = true;
      update();
      await uploadImage();
      Product product = Product(
        category: productCategory,
        brand: productBrand!.capitalizeFirst,
        name: productNameController.text,
        color: productColorController.text,
        price: double.parse(productPriceController.text),
        stock: int.parse(productStockController.text),
        image: downloadUrl,
        specifications: productSpecificationsController.text,
        sales: 0,
        hexColor: productHexColorController.text,
        memory: productMemoryController.text.isEmpty
            ? null
            : productMemoryController.text,
        wattage: productWattageController.text.isEmpty
            ? null
            : int.parse(productWattageController.text),
      );
      final instance = FirebaseFirestore.instance;
      if (productType == 'best') {
        DocumentReference documentReference =
            await instance.collection('bestSelling').add(
                  product.toJson(),
                );
        product.productId = documentReference.id;
        product.quantityInCart = 1;
        await documentReference
            .update({'quantityInCart': 1, 'productId': documentReference.id});
        bestSelling.add(product);
        clearAdd();
        addingProduct = false;
        update();
        return;
      } else if (productType == 'offer') {
        if (offers.length >= 3) {
          CommonFunctions().showDialogue(
            true,
            'You can not have more then 3 products as offers.',
            null,
            null,
            null,
          );
          clearAdd();
          addingProduct = false;
          update();
          return;
        }
        DocumentReference documentReference =
            await instance.collection('offers').add(
                  product.toJson(),
                );
        product.productId = documentReference.id;
        product.quantityInCart = 1;
        await documentReference
            .update({'quantityInCart': 1, 'productId': documentReference.id});
        offers.add(product);
        clearAdd();
        addingProduct = false;
        update();
        return;
      }
      QuerySnapshot querySnapshot = await instance
          .collection(category)
          .where('brand', isEqualTo: brand)
          .get();

      DocumentReference documentReference =
          await querySnapshot.docs.first.reference.collection('products').add(
                product.toJson(),
              );
      await documentReference
          .update({'quantityInCart': 1, 'productId': documentReference.id});
      DocumentReference reference =
          instance.collection('allProducts').doc(documentReference.id);
      await reference.set(
        product.toJson(),
      );
      await reference
          .update({'quantityInCart': 1, 'productId': documentReference.id});
      product.quantityInCart = 1;
      product.productId = documentReference.id;

      fetchedProducts[category]!.add(product);
      fetchedBrands[category]!.add(brand);
      allProducts.add(product);

      clearAdd();
      addingProduct = false;
      update();
    } on FirebaseException catch (e) {
      clearAdd();
      addingProduct = false;
      update();
      print(e.code);
    }
  }

  void clearAdd() {
    imageExists = true;
    image = null;
    productCategory = null;
    productBrand = null;
    productType = null;
    productNameController.clear();
    productColorController.clear();
    productPriceController.clear();
    productStockController.clear();
    productSpecificationsController.clear();
    productHexColorController.clear();
    productMemoryController.clear();
    productWattageController.clear();
    update();
  }

  void insertData(Product product) {
    productCategory = product.category;
    productBrand = product.brand!.toLowerCase();
    productNameController.text = product.name!;
    productColorController.text = product.color!;
    productHexColorController.text = product.hexColor!;
    productMemoryController.text = product.memory ?? '';
    productWattageController.text =
        product.wattage != null ? product.wattage.toString() : '';
    productPriceController.text = product.price.toString();
    productStockController.text = product.stock.toString();
    productSpecificationsController.text = product.specifications!;
    update();
  }

  bool editingProduct = false;
  void startEditingProduct() {
    editingProduct = true;
    update();
  }

  void cancelEditingProduct(Product product) {
    insertData(product);
    editingProduct = false;
    update();
  }

  void finishEditing() {
    editingProduct = false;
    update();
  }

  bool savingChanges = false;
  Future saveChanges(String category, String brand, Product product) async {
    try {
      print(product.productId);
      savingChanges = true;
      update();

      final instance = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await instance
          .collection(category)
          .where('brand', isEqualTo: brand)
          .get();

      if (image != null) {
        await uploadImage();
      }

      Product newProduct = Product(
        productId: product.productId,
        category: productCategory,
        brand: productBrand!.capitalizeFirst,
        name: productNameController.text,
        color: productColorController.text,
        price: double.parse(productPriceController.text),
        stock: int.parse(productStockController.text),
        image: downloadUrl ?? product.image,
        specifications: productSpecificationsController.text,
        sales: 0,
        hexColor: productHexColorController.text,
        memory: productMemoryController.text.isEmpty
            ? null
            : productMemoryController.text,
        wattage: productWattageController.text.isEmpty
            ? null
            : int.tryParse(productWattageController.text),
        quantityInCart: 1,
      );

      try {
        if (querySnapshot.docs.isNotEmpty) {
          await querySnapshot.docs.first.reference
              .collection('products')
              .doc(product.productId)
              .update(newProduct.toJson());
          fetchedProducts[category]![fetchedProducts[category]!.indexWhere(
              (target) => target.productId == product.productId)] = newProduct;
          update();
        } else {
          print('No matching documents found in category collection.');
        }
      } catch (e) {
        print('Error updating category collection: ${e.toString()}');
      }

      try {
        await instance.collection('allProducts').doc(product.productId).update(
              newProduct.toJson(),
            );
        allProducts[allProducts.indexWhere(
            (target) => target.productId == product.productId)] = newProduct;
        update();
      } catch (e) {
        print('Error updating allProducts collection: ${e.toString()}');
      }

      try {
        await instance.collection('bestSelling').doc(product.productId).update(
              newProduct.toJson(),
            );
        bestSelling[bestSelling.indexWhere(
            (target) => target.productId == product.productId)] = newProduct;
        update();
      } catch (e) {
        print('Error updating bestSelling collection: ${e.toString()}');
      }

      try {
        await instance.collection('offers').doc(product.productId).update(
              newProduct.toJson(),
            );
        offers[offers.indexWhere(
            (target) => target.productId == product.productId)] = newProduct;
        update();
      } catch (e) {
        print('Error updating offers collection: ${e.toString()}');
      }

      savingChanges = false;
      finishEditing();
    } on FirebaseException catch (e) {
      savingChanges = false;
      finishEditing();
      print('FirebaseException: ${e.code}');
    } catch (e) {
      savingChanges = false;
      finishEditing();
      print('Exception: ${e.toString()}');
    }
  }

  bool deletingProduct = false;
  Future deleteProduct(String category, String brand, Product product) async {
    try {
      deletingProduct = true;
      update();
      Get.dialog(
        Center(
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: MyColors().myBlue,
              strokeWidth: 2,
            ),
          ),
        ),
      );
      final instance = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await instance
          .collection(category)
          .where('brand', isEqualTo: brand)
          .get();
      await querySnapshot.docs.first.reference
          .collection('products')
          .doc(product.productId!)
          .delete();
      await instance.collection('allProducts').doc(product.productId!).delete();
      await instance.collection('bestSelling').doc(product.productId!).delete();
      await instance.collection('offers').doc(product.productId!).delete();
      fetchedProducts[category]!
          .removeWhere((item) => item.productId == product.productId);
      allProducts.removeWhere((item) => item.productId == product.productId);
      if (fetchedProducts[category]!
          .where((item) => item.productId == product.productId)
          .isEmpty) {
        fetchedBrands[category]!.remove(brand);
      }
      bestSelling.removeWhere((item) => item.productId == product.productId);
      offers.removeWhere((item) => item.productId == product.productId);
      searchResult.removeWhere((item) => item.productId == product.productId);
      deletingProduct = false;
      update();
      Get.back();
    } on FirebaseException catch (e) {
      Get.back();
      deletingProduct = false;
      update();
      print(e.code);
    }
  }
}
