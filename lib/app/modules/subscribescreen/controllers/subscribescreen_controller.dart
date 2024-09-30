import 'dart:async';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';

class SubscribescreenController extends GetxController {
  RxBool isSubscribed = false.obs;
  StreamSubscription<PurchasedItem?>? _purchaseUpdatedSubscription;
  StreamSubscription<PurchaseResult?>? _purchaseErrorSubscription;
  StreamSubscription<ConnectionResult>? _connectionSubscription;

  bool hideFreeTrial = false;
  List<IAPItem> productList = [];

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  @override
  void onClose() {
    _connectionSubscription?.cancel();
    _purchaseUpdatedSubscription?.cancel();
    _purchaseErrorSubscription?.cancel();
    // FlutterInappPurchase.instance.endConnection();
    super.onClose();
  }

  Future<void> _initialize() async {
    // Initialize connection
    _connectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((result) {
      print('Connection result: $result');
    });

    // Listen to purchase updates
    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((purchasedItem) {
      _handlePurchaseUpdate(purchasedItem);
    });

    // Listen to purchase errors
    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('Purchase Error: $purchaseError');
    });

    await FlutterInappPurchase.instance.initialize();
    await _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      List<IAPItem> items = await FlutterInappPurchase.instance
          .getSubscriptions(['mopedgps_six_month', 'mopedgps_monthly']);
      productList = items;
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void buySubscription(IAPItem item) async {
    try {
      await FlutterInappPurchase.instance.requestSubscription(item.productId!);
    } catch (e) {
      print('Error purchasing product: $e');
    }
  }

  void _handlePurchaseUpdate(PurchasedItem? purchasedItem) {
    if (purchasedItem != null) {
      // Update subscription status based on successful purchase
      isSubscribed.value = true;
    }
  }
}
