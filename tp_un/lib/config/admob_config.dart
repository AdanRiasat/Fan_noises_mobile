import 'env.dart';

class AdMobConfig {
  static const _testBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const _testInterstitial = 'ca-app-pub-3940256099942544/1033173712';

  static const _prodBanner = 'ca-app-pub-6469646834377281/1830308526';
  static const _prodInterstitial = 'ca-app-pub-6469646834377281/8507397518';

  static String get banner => Env.isProd ? _prodBanner : _testBanner;

  static String get interstitial =>
      Env.isProd ? _prodInterstitial : _testInterstitial;
}
