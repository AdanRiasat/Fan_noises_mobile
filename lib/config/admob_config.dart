import 'package:flutter/foundation.dart';

import 'env.dart';

class AdMobConfig {
  static const _testBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const _testInterstitial = 'ca-app-pub-3940256099942544/1033173712';

  @visibleForTesting
  static const prodPublisher = 'ca-app-pub-6469646834377281';

  @visibleForTesting
  static const prodBanner = '$prodPublisher/1830308526';

  @visibleForTesting
  static const prodInterstitial = '$prodPublisher/8507397518';

  static String get banner => Env.isProd ? prodBanner : _testBanner;

  static String get interstitial =>
      Env.isProd ? prodInterstitial : _testInterstitial;
}
