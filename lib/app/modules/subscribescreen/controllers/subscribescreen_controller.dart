import 'dart:async';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';

class SubscribescreenController extends GetxController {
  RxBool isSubscribed = false.obs; // Track subscription status
  RxList<IAPItem> productList = <IAPItem>[].obs; // Use RxList for reactivity
  StreamSubscription<PurchasedItem?>? _purchaseUpdatedSubscription;
  StreamSubscription<PurchaseResult?>? _purchaseErrorSubscription;
  StreamSubscription<ConnectionResult>? _connectionSubscription;

  @override
  void onInit() {
    super.onInit();
    // Initialize In-App Purchase
    FlutterInappPurchase.instance.initialize();

    _connectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    // Fetch subscription products from Google Play
    _getSubscriptionProducts();

    // Set up purchase update listeners
    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((PurchasedItem? item) {
      _handlePurchaseUpdated(item);
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((error) {
      print('purchase-error: $error');
      // Handle purchase error
    });

    // Optionally, restore purchases (for checking if user is still subscribed)
    _restorePurchases();
  }

  Future<void> _getSubscriptionProducts() async {
    try {
      // Fetch subscription products (make sure your products are marked as subscriptions in Google Play)
      List<IAPItem> items = await FlutterInappPurchase.instance
          .getSubscriptions(['weekly']); // Subscription product IDs

      productList.assignAll(items);
      print(items);
      for (var item in items) {
        print("Product ID: ${item.productId}");
        print("Localized Price: ${item.localizedPrice}");
        print("Original JSON: ${item.originalJson ?? 'No JSON available'}");
      }
    } catch (error) {
      print('Error fetching subscription products: $error');
    }
  }

  Future<void> _restorePurchases() async {
    try {
      // List<PurchasedItem?> can contain null elements, so adjust the assignment accordingly
      List<PurchasedItem?>? purchases =
          await FlutterInappPurchase.instance.getAvailablePurchases();
      if (purchases != null) {
        for (var purchase in purchases) {
          if (purchase != null) {
            print('Restored Purchase: ${purchase.productId}');
            // Verify and update subscription status
            if (_isSubscriptionActive(purchase)) {
              isSubscribed.value = true;
            }
          }
        }
      }
    } catch (error) {
      print('Error restoring purchases: $error');
    }
  }

  bool _isSubscriptionActive(PurchasedItem purchasedItem) {
    // Add your logic to check whether the subscription is active
    // This might involve verifying expiration dates or receipts
    return true; // Placeholder for real logic
  }

  void buySubscription(String productId) async {
    try {
      await FlutterInappPurchase.instance
          .requestSubscription(productId)
          .then((response) {
        print(response);
      });
    } catch (error) {
      print('Error purchasing subscription: ${error.toString()}');
      // Show a snackbar for user feedback
      Get.snackbar("Purchase Error", error.toString());
    }
  }

  void _handlePurchaseUpdated(PurchasedItem? purchasedItem) {
    if (purchasedItem != null) {
      // Verify subscription and update UI state
      print('Subscription successful: ${purchasedItem.productId}');
      isSubscribed.value = true;

      // Show all transaction details
      _showTransactionDetails(purchasedItem);
    }
  }

  // Method to display transaction details
  void _showTransactionDetails(PurchasedItem purchasedItem) {
    String details = "Product ID: ${purchasedItem.productId}\n"
        "Transaction ID: ${purchasedItem.transactionId}\n"
        "Purchase Time: ${purchasedItem.transactionDate}\n"
        "Purchase State: ${purchasedItem.purchaseStateAndroid}\n";

    // Optionally, you can show this information in a dialog or snackbar
    Get.snackbar("Transaction Details", details);
  }

  // Method to cancel subscription
  void cancelSubscription() {
    // Usually, you redirect to Play Store subscription management
    // Use an URL scheme to open subscription management
    // Android intent to open subscription management
    const url = 'https://play.google.com/store/account/subscriptions';
    print('Redirecting to subscription management: $url');
    // Open the URL in the browser or WebView
    Get.toNamed(url); // Adjust as needed for navigation
  }

  @override
  void onClose() {
    _connectionSubscription?.cancel();
    _purchaseUpdatedSubscription?.cancel();
    _purchaseErrorSubscription?.cancel();
    productList.clear();
    super.onClose();
  }
}
