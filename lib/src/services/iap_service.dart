import 'package:cloud_functions/cloud_functions.dart';
import 'package:exercise_journal/src/services/firestore_user_service.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class IAPService {
  String uid;

  IAPService(this.uid);

  void listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((purchaseDetails) async {
      print('purchaseDetails.status ${purchaseDetails.status}');
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        bool validPurchase = await _verifyPurchase(purchaseDetails);
        if (validPurchase) {
          _handleSuccessfulPurchase(purchaseDetails);
        }
        // else {
        //  //  If purchase is not valid I can show a modal saying user was not charged
        // }
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        print('purchase marked complete');
      }
    });
  }

  // 'progressable_premium_09.2022',
  // 'progressable_unlimited_month_09_2022',
  // 'progressable_unlimited_year_09_2022',

  void _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) {
    if (purchaseDetails.productID == 'progressable_premium_09.2022') {
      FirestoreService().setAccountType(uid: uid, type: 'premium');
    }
    if (purchaseDetails.productID == 'progressable_unlimited_month_09_2022' ||
        purchaseDetails.productID == 'progressable_unlimited_year_09_2022') {
      FirestoreService().setAccountType(uid: uid, type: 'unlimited');
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    print("verifying Purchase");
    final verifier = FirebaseFunctions.instance.httpsCallable('verifyPurchase');
    final results = await verifier({
      'source': purchaseDetails.verificationData.source,
      'verificationData':
          purchaseDetails.verificationData.serverVerificationData,
      'productId': purchaseDetails.purchaseID,
    });
    print("Called verify purchase with following results $results");
    return results.data as bool;
  }
}
