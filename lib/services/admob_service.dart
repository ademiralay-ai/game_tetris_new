// AdMob service - Web'de no-op, mobilde gerçek reklamlar
import 'package:flutter/foundation.dart';

// Gerçek AdMob ID'leri
const String _bannerAdUnitId = 'ca-app-pub-6648140774232557/5915022913';
const String _interstitialAdUnitId = 'ca-app-pub-6648140774232557/4471138798';
const String _rewardedAdUnitId = 'ca-app-pub-6648140774232557/6626528840';

// Koşullu import ile web'de google_mobile_ads yüklenmez
import 'admob_service_mobile.dart'
    if (dart.library.html) 'admob_service_web.dart';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  bool get isSupported => !kIsWeb;

  final AdMobImpl _impl = AdMobImpl();

  Future<void> initialize() async {
    if (kIsWeb) {
      debugPrint('[AdMob] Web platform - ads disabled');
      return;
    }
    await _impl.initialize();
    debugPrint('[AdMob] Initialized');
  }

  Future<void> loadBannerAd() async {
    if (kIsWeb) return;
    await _impl.loadBannerAd(_bannerAdUnitId);
    debugPrint('[AdMob] Banner ad loaded');
  }

  Future<void> loadInterstitialAd() async {
    if (kIsWeb) return;
    await _impl.loadInterstitialAd(_interstitialAdUnitId);
    debugPrint('[AdMob] Interstitial ad loaded');
  }

  Future<void> showInterstitialAd() async {
    if (kIsWeb) return;
    await _impl.showInterstitialAd();
    debugPrint('[AdMob] Interstitial ad shown');
  }

  Future<bool> showRewardedAd({required Function() onReward}) async {
    if (kIsWeb) {
      // Web'de ödülü simüle et
      onReward();
      return true;
    }
    return _impl.showRewardedAd(
      adUnitId: _rewardedAdUnitId,
      onReward: onReward,
    );
  }

  void disposeBannerAd() {
    if (kIsWeb) return;
    _impl.disposeBannerAd();
    debugPrint('[AdMob] Banner ad disposed');
  }
}
