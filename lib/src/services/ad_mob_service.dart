import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  Future<InitializationStatus> initialisation;

  AdMobService(this.initialisation);

  String? get bannerAdUnitId {
    if (kReleaseMode) {
      if (Platform.isIOS) {
        return "ca-app-pub-7135826383050936/1937574379";
      } else if (Platform.isAndroid) {
        return "ca-app-pub-7135826383050936/4756428967";
      }
    } else {
      if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/2934735716";
      } else if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/6300978111";
      }
    }
    return null;
  }

  final BannerAdListener bannerListener = BannerAdListener(
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print('Ad failed to lead: $error');
    },
    onAdOpened: (Ad ad) => print('Ad opened'),
    onAdClosed: (Ad ad) => print('Ad closed'),
  );
}
