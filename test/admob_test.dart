import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fan_noises/config/admob_config.dart';
import 'package:fan_noises/config/env.dart';

const _testPublisher = 'ca-app-pub-3940256099942544';
final _adUnitPattern = RegExp(r'^ca-app-pub-\d{16}/\d{10}$');

void main() {
  test('dev serves test ads', () {
    expect(Env.isProd, isFalse);
    expect(AdMobConfig.banner, startsWith(_testPublisher));
    expect(AdMobConfig.interstitial, startsWith(_testPublisher));
  });

  group('prod serves real ads', () {
    test('', () {
      for (final id in [AdMobConfig.prodBanner, AdMobConfig.prodInterstitial]) {
        expect(id, matches(_adUnitPattern));
        expect(id, startsWith('${AdMobConfig.prodPublisher}/'));
        expect(id, isNot(startsWith(_testPublisher)));
      }
    });

    test('banner and interstitial are distinct', () {
      expect(AdMobConfig.prodBanner, isNot(AdMobConfig.prodInterstitial));
    });

    test('publisher matches the AndroidManifest app ID', () {
      final manifest = File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync();

      final appId = RegExp(
        r'android:name="com\.google\.android\.gms\.ads\.APPLICATION_ID"\s+'
        r'android:value="([^"]+)"',
      ).firstMatch(manifest)?.group(1);

      expect(
        appId,
        isNotNull,
        reason: 'AdMob APPLICATION_ID meta-data is missing from the manifest',
      );
      expect(appId, startsWith('${AdMobConfig.prodPublisher}~'));
    });
  });
}
