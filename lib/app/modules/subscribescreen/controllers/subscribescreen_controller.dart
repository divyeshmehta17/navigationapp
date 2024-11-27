import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/subscriptions.dart';
import '../../../services/dio/api_service.dart';

class SubscribescreenController extends GetxController {
  RxBool isSubscribed = false.obs; // Track subscription status
  RxList<IAPItem> productList = <IAPItem>[].obs; // Use RxList for reactivity
  StreamSubscription<PurchasedItem?>? _purchaseUpdatedSubscription;
  StreamSubscription<PurchaseResult?>? _purchaseErrorSubscription;
  StreamSubscription<ConnectionResult>? _connectionSubscription;
  RxInt selectedSubscriptionIndex = 0.obs; // Track selected subscription index
  Rxn<Subscriptions> subscriptions = Rxn();
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

  String getFormattedDividedPrice(IAPItem item, int divisor) {
    // Extract the numeric part by removing non-numeric characters (like the currency symbol)
    String priceWithoutSymbol =
        item.localizedPrice!.replaceAll(RegExp(r'[^\d.]'), '');

    // Convert the extracted price to double
    double numericPrice = double.tryParse(priceWithoutSymbol) ?? 0.0;

    // Perform the division
    double dividedPrice = numericPrice / divisor;

    // Reformat the result with the currency symbol from localizedPrice
    return "${item.localizedPrice!.substring(0, 1)}${dividedPrice.toStringAsFixed(2)}";
  }

// Usage in your Text widget

  Future<void> _getSubscriptionProducts() async {
    try {
      // Fetch subscription products (make sure your products are marked as subscriptions in Google Play)
      List<IAPItem> items = await FlutterInappPurchase.instance
          .getSubscriptions([
        'montly_subscription',
        '6month_subscription'
      ]); // Subscription product IDs

      productList.assignAll(items);
      print(items[0]);
      print(items[1]);
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
      await FlutterInappPurchase.instance.requestSubscription(productId);
    } catch (error) {
      print('Error purchasing subscription: ${error.toString()}');
      // Show a snackbar for user feedback
      Get.snackbar("Purchase Error", error.toString());
    }
  }

  Future<void> _handlePurchaseUpdated(PurchasedItem? purchasedItem) async {
    if (purchasedItem != null) {
      // Verify subscription and update UI state
      await APIManager.postSubscribe(
              purchaseToken: 'test', productId: 'test', transactionId: 'test')
          .then((response) {
        subscriptions.value = response.data;
        print(subscriptions.value!.data!.purchaseToken);
      });
      isSubscribed.value = true;
      FlutterInappPurchase.instance
          .acknowledgePurchaseAndroid(purchasedItem.purchaseToken.toString());
      // Acknowledge successful purchase to the user
      Get.snackbar(
        "Subscription Successful",
        "You have successfully subscribed to ${purchasedItem.productId}. Enjoy the premium features!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

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
  void cancelSubscription() async {
    // Properly construct the URL
    Uri url = Uri.parse('https://play.google.com/store/account/subscriptions');

    // Check if the URL can be launched and launch it
    if (await canLaunchUrl(url)) {
      await launchUrl(url,
          mode: LaunchMode.externalApplication); // Launch in external browser
      print('Redirecting to subscription management: $url');
    } else {
      print('Could not launch $url');
      // Optionally show a snackbar or dialog to inform the user
      Get.snackbar("Error", "Could not open subscription management page.");
    }
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
