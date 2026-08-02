import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:fan_noises/admob/consent_manager.dart';
import 'package:fan_noises/config/admob_config.dart';
import 'package:fan_noises/widgets/bottom_controls.dart';
import 'package:fan_noises/widgets/fan_widget.dart';

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
  Duration _remainingDuration = Duration.zero;

  DateTime? _playStartTime;
  Duration _totalPlayTime = Duration.zero;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialReady = false;

  late final Ticker _ticker;
  final ValueNotifier<double> _fanAngle = ValueNotifier(0);
  double _fanSpeed = 0; // current angular speed, radians/sec
  double _targetSpeed = 0; // 0 when stopping, _maxFanSpeed when spinning
  Duration _lastTick = Duration.zero;

  static const double _maxFanSpeed = 3 * math.pi; // ~1.5 turns/sec
  static const double _accel = _maxFanSpeed / 2.0; // ramps over ~2s

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
      _remainingDuration = duration;
    });
  }

  Future<void> _play() async {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _startSpin();
    } else {
      _stopSpin();
    }

    if (!_isPlaying) {
      _accrueSessionPlayTime();
      _maybeShowInterstitial();
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
        _stopSpin();
        player.stop();

        _accrueSessionPlayTime();
        _maybeShowInterstitial();
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

  void _onTick(Duration elapsed) {
    final double dt = (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;

    if (_fanSpeed < _targetSpeed) {
      _fanSpeed = math.min(_targetSpeed, _fanSpeed + _accel * dt);
    } else if (_fanSpeed > _targetSpeed) {
      _fanSpeed = math.max(_targetSpeed, _fanSpeed - _accel * dt);
    }

    _fanAngle.value -= _fanSpeed * dt; // negative keeps the spin direction

    if (_fanSpeed == 0 && _targetSpeed == 0) {
      _ticker.stop();
    }
  }

  void _startSpin() {
    _targetSpeed = _maxFanSpeed;
    if (!_ticker.isActive) {
      _lastTick = Duration.zero;
      _ticker.start();
    }
  }

  void _stopSpin() {
    _targetSpeed = 0;
  }

  void _accrueSessionPlayTime() {
    if (_playStartTime == null) return;

    _totalPlayTime += DateTime.now().difference(_playStartTime!);
    _playStartTime = null;
  }

  void _maybeShowInterstitial() {
    if (_totalPlayTime < const Duration(minutes: 10)) return;
    if (!_isInterstitialReady || _interstitialAd == null) return;

    _interstitialAd!.show();
    _totalPlayTime = Duration.zero;
  }

  void _loadInterstitial() {
    if (!ConsentManager.canRequestAds.value) return;

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
    ConsentManager.canRequestAds.addListener(_loadInterstitial);
    _loadInterstitial();

    _ticker = createTicker(_onTick);
  }

  @override
  void dispose() {
    ConsentManager.canRequestAds.removeListener(_loadInterstitial);
    _stopTimer();
    player.stop();
    player.dispose();
    _ticker.dispose();
    _fanAngle.dispose();
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
                angle: _fanAngle,
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
