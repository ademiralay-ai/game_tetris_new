// Mobile stub - Android debug derlemesini reklam eklentisinden bağımsız tutar.
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
