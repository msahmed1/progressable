import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/loading_indicator.dart';
import 'package:exercise_journal/src/widgets/text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

const List<String> _productIds = <String>[
  'progressable_premium_09.2022',
  'progressable_unlimited_month_09_2022',
  'progressable_unlimited_year_09_2022',
];

class StoreView extends StatefulWidget {
  static const String id = 'store_view';

  const StoreView({super.key});

  @override
  State<StoreView> createState() => _StoreViewState();
}

enum ProductStatus {
  purchasable,
  purchased,
  pending,
}

class PurchasableProduct {
  String get id => productDetails.id;

  String get title => productDetails.title;

  String get description => productDetails.description;

  String get price => productDetails.price;
  ProductStatus status;
  ProductDetails productDetails;

  PurchasableProduct(this.productDetails) : status = ProductStatus.purchasable;
}

class _StoreViewState extends State<StoreView> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  bool _isAvailable = false;
  String? _notice;
  List<ProductDetails> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    initStoreInfo();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    setState(() {
      _isAvailable = isAvailable;
    });

    if (!_isAvailable) {
      setState(() {
        _loading = false;
        _notice = "There are no upgrades at this time, no connection";
      });
      return;
    }
//////////////////////
    const ids = <String>{
      'progressable_premium_09.2022',
      'progressable_unlimited_month_09_2022',
      'progressable_unlimited_year_09_2022',
    };

    final response = await _inAppPurchase.queryProductDetails(ids);
    for (var element in response.notFoundIDs) {
      debugPrint('Purchase $element not found');
    }
    List<PurchasableProduct> products =
        response.productDetails.map((e) => PurchasableProduct(e)).toList();
    print('##############---------->products: $products');
    // storeState = StoreState.available;
///////////////////
    // get IAP.
    final ProductDetailsResponse productDetailsResponse =
        await _inAppPurchase.queryProductDetails(_productIds.toSet());

    setState(() {
      _loading = false;
      _products = productDetailsResponse.productDetails;
      print('product details: ${productDetailsResponse.productDetails}');
      print('product not found: ${productDetailsResponse.notFoundIDs}');
    });

    if (productDetailsResponse.error != null) {
      setState(() {
        _notice = "There was a problem connecting to the store";
      });
    } else if (productDetailsResponse.productDetails.isEmpty) {
      setState(() {
        _notice = "There are no upgrades at this time";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return platformApp(context);
  }

  Widget platformApp(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: GestureDetector(
            child: Icon(
              CupertinoIcons.left_chevron,
              color: AppColours.primaryButton,
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
          middle: Text(
            'Store',
            style: TextStyles.title,
          ),
          backgroundColor: AppColours.appBar,
        ),
        child: SafeArea(
          child: pageBody(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.xmark,
              color: AppColours.primaryButton,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Store",
            style: TextStyles.title,
          ),
          backgroundColor: AppColours.appBar,
        ),
        body: SafeArea(
          child: pageBody(),
        ),
      );
    }
  }

  Widget pageBody() {
    return Column(
      children: [
        if (_notice != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_notice!),
          ),
        if (_loading) const LoadingIndicator(text: 'Retrieving store data'),
        Expanded(
          child: ListView.builder(
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final ProductDetails productDetails = _products[index];

              return Card(
                color: AppColours.forground,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _getIAPIcon(productDetails.id),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            productDetails.title,
                            style: TextStyles.title.copyWith(fontSize: null),
                            maxFontSize: 22,
                            maxLines: 1,
                          ),
                          AutoSizeText(
                            productDetails.description,
                            style: TextStyles.subTitle.copyWith(fontSize: null),
                            minFontSize: 14,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          late PurchaseParam purchaseParam;

                          if (Platform.isAndroid) {
                            purchaseParam = GooglePlayPurchaseParam(
                              productDetails: productDetails,
                            );
                          } else {
                            purchaseParam =
                                PurchaseParam(productDetails: productDetails);
                          }

                          // if (_consumableIds.contains(productDetails.id)) {
                          //   InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
                          // } else {
                          InAppPurchase.instance
                              .buyNonConsumable(purchaseParam: purchaseParam);
                          // }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                            AppColours.primaryButton,
                          ),
                        ),
                        child: _buyText(productDetails),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        _buildRestoreButton(),
      ],
    );
  }

  Widget _getIAPIcon(productId) {
    if (productId == "progressable_premium_09.2022") {
      return Icon(
        Icons.brightness_7_outlined,
        size: 50,
        color: AppColours.primaryButton,
      );
    } else if (productId == "progressable_unlimited_month_09_2022") {
      return Icon(
        Icons.brightness_5,
        size: 50,
        color: AppColours.primaryButton,
      );
    } else if (productId == "progressable_unlimited_year_09_2022") {
      return Icon(
        Icons.brightness_7,
        size: 50,
        color: AppColours.primaryButton,
      );
    } else {
      return Icon(
        Icons.post_add_outlined,
        size: 50,
        color: AppColours.primaryButton,
      );
    }
  }

  Widget _buyText(ProductDetails productDetails) {
    if (productDetails.id == "unlimited_yt_monthly") {
      return Text("${productDetails.price} / month");
    } else if (productDetails.id == "unlimited_yt_yearly") {
      return Text("${productDetails.price} / year");
    } else {
      return Text("Buy for ${productDetails.price}");
    }
  }

  Widget _buildRestoreButton() {
    if (_loading) {
      return Container();
    }

    return PlainTextButton(
      buttonText: 'Restore Purchases',
      onPressed: () => _inAppPurchase.restorePurchases(),
    );
  }
}
