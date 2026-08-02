import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ConsentManager {
  ConsentManager._();

  static const List<String> _debugDeviceIds = <String>[];

  static final ValueNotifier<bool> canRequestAds = ValueNotifier<bool>(false);

  static final ValueNotifier<bool> privacyOptionsRequired = ValueNotifier<bool>(
    false,
  );

  static bool _adsInitialized = false;

  static Future<void> gatherConsentAndInitializeAds() async {
    await _initializeAdsIfAllowed();

    final params = ConsentRequestParameters(
      consentDebugSettings: kDebugMode && _debugDeviceIds.isNotEmpty
          ? ConsentDebugSettings(
              debugGeography: DebugGeography.debugGeographyEea,
              testIdentifiers: _debugDeviceIds,
            )
          : null,
    );

    final updated = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        await ConsentForm.loadAndShowConsentFormIfRequired(
          (error) => _logFormError('loadAndShowConsentFormIfRequired', error),
        );
        if (!updated.isCompleted) updated.complete();
      },
      (error) {
        _logFormError('requestConsentInfoUpdate', error);
        if (!updated.isCompleted) updated.complete();
      },
    );
    await updated.future;

    await _initializeAdsIfAllowed();
    await _refreshPrivacyOptionsRequirement();
  }

  /// Reopens the consent form from the drawer. Returns false when the form
  /// could not be shown, so the caller can tell the user instead of leaving the
  /// menu entry looking dead.
  static Future<bool> showPrivacyOptionsForm() async {
    final dismissed = Completer<bool>();
    await ConsentForm.showPrivacyOptionsForm((error) {
      _logFormError('showPrivacyOptionsForm', error);
      if (!dismissed.isCompleted) dismissed.complete(error == null);
    });
    final shown = await dismissed.future;

    await _initializeAdsIfAllowed();
    await _refreshPrivacyOptionsRequirement();

    return shown;
  }

  static void _logFormError(String stage, FormError? error) {
    if (error == null) return;

    if (kDebugMode) {
      debugPrint(
        'ConsentManager.$stage failed: '
        '[${error.errorCode}] ${error.message}',
      );
    }
  }

  static Future<void> _initializeAdsIfAllowed() async {
    if (_adsInitialized) return;
    if (!await ConsentInformation.instance.canRequestAds()) return;

    _adsInitialized = true;
    await MobileAds.instance.initialize();

    if (kDebugMode && _debugDeviceIds.isNotEmpty) {
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: _debugDeviceIds),
      );
    }

    canRequestAds.value = true;
  }

  static Future<void> _refreshPrivacyOptionsRequirement() async {
    final status = await ConsentInformation.instance
        .getPrivacyOptionsRequirementStatus();
    privacyOptionsRequired.value =
        status == PrivacyOptionsRequirementStatus.required;
  }
}
