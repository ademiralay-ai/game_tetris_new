import 'package:flutter/foundation.dart';
import 'admob_service_mobile.dart'
    if (dart.library.js) 'admob_service_web.dart'
    if (dart.library.html) 'admob_service_web.dart';

const String _rewardedAdUnitId = 'ca-app-pub-6648140774232557/6626528840';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  bool get isSupported => !kIsWeb;

  final AdMobImpl _impl = AdMobImpl();

  Future<void> initialize() async {
    if (kIsWeb) return;
    await _impl.initialize();
  }

  Future<void> showInterstitialAd() async {
    if (kIsWeb) return;
    await _impl.showInterstitialAd();
  }

  Future<bool> showRewardedAd({required Function() onReward}) async {
    if (kIsWeb) {
      onReward();
      return true;
    }
    return _impl.showRewardedAd(
      adUnitId: _rewardedAdUnitId,
      onReward: onReward,
    );
  }
}
