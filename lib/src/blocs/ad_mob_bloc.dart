import 'package:exercise_journal/src/services/ad_mob_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:rxdart/rxdart.dart';

class AdMobBloc {
  final _initAdFuture = MobileAds.instance.initialize();
  late final AdMobService adMobService;

  AdMobBloc() {
    adMobService = AdMobService(_initAdFuture);
  }

  Future<dynamic> getBannerAd() {
    return adMobService.initialisation.then((value) {
      return (BannerAd(
        size: AdSize.fullBanner,
        adUnitId: adMobService.bannerAdUnitId!,
        listener: adMobService.bannerListener,
        request: const AdRequest(),
      )..load());
    });
  }
}
