import 'dart:async';

import 'package:exercise_journal/src/services/iap_service.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:rxdart/rxdart.dart';

class IAPBloc {
  // static InAppPurchase? _instance;
  late StreamSubscription<List<PurchaseDetails>> _iapSubscription;
  final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

  final _uid = BehaviorSubject<String>();

  Function(String) get changeUID => _uid.sink.add;

  //
  // static set instance(InAppPurchase value) {
  //   _instance = value;
  // }
  //
  // static InAppPurchase get instance {
  //   _instance ??= InAppPurchase.instance;
  //   return _instance!;
  // }

  // late StreamSubscription<List<PurchaseDetails>> _iap_subscription;


  IAPBloc(){
    purchaseUpdated.listen(
          (purchaseDetailsList) {
        IAPService(_uid.value)
            .listenToPurchaseUpdated(
          purchaseDetailsList as List<PurchaseDetails>,
        );
      },
      onDone: () {
        _iapSubscription.cancel();
      },
      onError: (error) {
        _iapSubscription.cancel();
      },
    ) as StreamSubscription<List<PurchaseDetails>>;
  }
}
