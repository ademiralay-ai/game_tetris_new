// Web stub - google_mobile_ads web'de desteklenmez
class AdMobImpl {
  Future<void> initialize() async {}
  Future<void> loadBannerAd(String adUnitId) async {}
  Future<void> loadInterstitialAd(String adUnitId) async {}
  Future<void> showInterstitialAd() async {}
  Future<bool> showRewardedAd({
    required String adUnitId,
    required Function() onReward,
  }) async {
    onReward();
    return true;
  }
  void disposeBannerAd() {}
}
