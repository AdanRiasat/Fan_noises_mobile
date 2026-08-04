import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:fan_noises/admob/consent_manager.dart';
import 'package:fan_noises/config/admob_config.dart';

class FooterAdBanner extends StatefulWidget {
  const FooterAdBanner({super.key});

  @override
  State<FooterAdBanner> createState() => _FooterAdBannerState();
}

class _FooterAdBannerState extends State<FooterAdBanner> {
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;

  @override
  void initState() {
    super.initState();

    ConsentManager.canRequestAds.addListener(_onConsentChanged);
    _onConsentChanged();
  }

  void _onConsentChanged() {
    if (!ConsentManager.canRequestAds.value || _bannerAd != null) return;

    _bannerAd = BannerAd(
      adUnitId: AdMobConfig.banner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) return;
          setState(() => _isBannerLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    ConsentManager.canRequestAds.removeListener(_onConsentChanged);
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBannerLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: _bannerAd!.size.height.toDouble(),
      width: _bannerAd!.size.width.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
