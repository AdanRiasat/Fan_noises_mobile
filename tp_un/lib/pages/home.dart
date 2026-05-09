import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tp_un/config/admob_config.dart';
import 'package:tp_un/widgets/drawer.dart';
import 'package:tp_un/widgets/bottom_controls.dart';
import 'package:tp_un/widgets/fan_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final player = AudioPlayer();

  String _currentAudio = "";
  bool _isPlaying = false;
  bool _isCustom = false;

  Timer? _timer;
  Duration _duration = Duration.zero;
  Duration _remainingDuration = Duration.zero;

  DateTime? _playStartTime;
  Duration _totalPlayTime = Duration.zero;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialReady = false;

  late final AnimationController _fanController;

  void _onFanSelected(String audioPath) {
    setState(() {
      _currentAudio = audioPath;
    });
  }

  void _checkFanType(bool isCustom) {
    setState(() {
      _isCustom = isCustom;
    });
  }

  void _onTimerChanged(Duration duration) {
    _timer?.cancel();

    setState(() {
      _duration = duration;
      _remainingDuration = duration;
    });
  }

  Future<void> _play() async {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _fanController.repeat();
    } else {
      _fanController.stop(canceled: false);
    }

    if (!_isPlaying && _playStartTime != null) {
      final sessionTime = DateTime.now().difference(_playStartTime!);
      _totalPlayTime += sessionTime;
      _playStartTime = null;

      if (_totalPlayTime >= const Duration(minutes: 10) &&
          _isInterstitialReady &&
          _interstitialAd != null) {
        _interstitialAd!.show();
        _totalPlayTime = Duration.zero;
      }
    }

    await player.stop();
    _stopTimer();

    if (!_isPlaying) {
      await AudioPlayer.clearAssetCache();
    }

    if (_isPlaying) {
      _playStartTime = DateTime.now();

      _startTimer();
      await player.setLoopMode(LoopMode.one);

      if (_isCustom) {
        await player.setFilePath(_currentAudio);
      } else {
        await player.setAsset(_currentAudio);
      }

      await player.play();
    }
  }

  void _startTimer() {
    if (_remainingDuration.inSeconds <= 0) return;

    _stopTimer();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingDuration.inSeconds <= 1) {
        timer.cancel();
        setState(() {
          _remainingDuration = Duration.zero;
          _isPlaying = false;
        });
        _fanController.stop();
        player.stop();

        if (_duration.inMinutes >= 10 &&
            _isInterstitialReady &&
            _interstitialAd != null) {
          _interstitialAd!.show();
        }
      } else {
        setState(() {
          _remainingDuration -= Duration(seconds: 1);
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: AdMobConfig.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialReady = false;
              _loadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialReady = false;
              _loadInterstitial();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isInterstitialReady = false;
          _interstitialAd = null;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadInterstitial();

    _fanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _stopTimer();
    player.stop();
    player.dispose();
    _fanController.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Center(
              child: FanWidget(
                controller: _fanController,
                size: MediaQuery.of(context).size.width * 1.15,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFF59556F),
              child: IconButton(
                icon: _isPlaying
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
                iconSize: 32,
                color: Colors.white,
                onPressed: () async {
                  await _play();
                },
              ),
            ),
          ),

          BottomControls(
            onFanSelected: _onFanSelected,
            checkFanType: _checkFanType,
            onTimerSelected: _onTimerChanged,
            remainingDuration: _remainingDuration,
          ),
        ],
      ),
    );
  }
}
