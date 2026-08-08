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
  static const double _spinRampSeconds = 2.0;
  static const double _accel = _maxFanSpeed / _spinRampSeconds;

  static const double _maxTickDelta = 0.05;

  double _fadeLevel = 0; // linear in 0..1
  double _fadeTarget = 0; // 0 when fading out, 1 when fading in
  double _fadeRate = 0; // level units per second
  int _pushedStep = -1; // last quantized step sent to the player
  bool _stopPending = false; // a fade-out that must end in player.stop()
  bool _audioReady = false;
  int _playToken = 0; // invalidates loads left in flight by a pause
  String? _loadedAudio;
  Timer? _fadeWatchdog;
  Future<void> _audioOps = Future<void>.value();

  static const double _fadeInSeconds = _spinRampSeconds;
  static const double _fadeOutSeconds = 0.4;
  static const double _fadeFloorDb = -45.0;
  static const int _volumeSteps = 64;

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

  void _play() {
    final bool shouldPlay = !_isPlaying;

    setState(() {
      _isPlaying = shouldPlay;
    });

    if (shouldPlay) {
      _startPlayback();
    } else {
      _pausePlayback();
    }
  }

  void _startPlayback() {
    _stopPending = false; // cancel a teardown deferred by a fade in flight
    _startSpin();

    _playStartTime = DateTime.now();
    _startTimer();

    if (_loadedAudio == _currentAudio) {
      _beginFade(1, _fadeInSeconds);
      return;
    }

    _audioReady = false;
    _beginFade(1, _fadeInSeconds);
    _loadAndPlay(++_playToken);
  }

  void _pausePlayback() {
    _stopSpin();
    _stopTimer();
    _accrueSessionPlayTime();

    _stopPending = true;
    _beginFade(0, _fadeOutSeconds);
  }

  void _loadAndPlay(int token) {
    final String source = _currentAudio;
    final bool custom = _isCustom;

    _enqueue(() async {
      if (token != _playToken) return;
      await player.stop();
      if (token != _playToken) return;

      _pushedStep = -1;
      _applyVolume();

      await player.setLoopMode(LoopMode.one);
      if (token != _playToken) return;

      try {
        if (custom) {
          await player.setFilePath(source);
        } else {
          await player.setAsset(source);
        }
      } catch (_) {
        if (token == _playToken) _onLoadFailed();
        return;
      }
      if (token != _playToken) return;

      _loadedAudio = source;
      _audioReady = true; // releases the held fade-in
      _armFadeWatchdog();
      _ensureTicking();

      unawaited(player.play().catchError((Object _) {}));
    });
  }

  void _completeStop() {
    _stopPending = false;
    _fadeWatchdog?.cancel();
    _fadeWatchdog = null;
    _audioReady = false;
    _loadedAudio = null;
    _pushedStep = -1;

    final int token = ++_playToken; // abandon any load still in flight

    _enqueue(() async {
      await player.stop();
      if (token != _playToken) return; // play was tapped again

      if (mounted) _maybeShowInterstitial();

      await AudioPlayer.clearAssetCache();
    });
  }

  void _onLoadFailed() {
    _audioReady = false;
    _loadedAudio = null;
    _stopPending = false;
    _fadeLevel = 0;
    _fadeTarget = 0;
    _pushedStep = -1;
    _stopSpin();
    if (mounted) setState(() => _isPlaying = false);
  }

  Future<void> _enqueue(Future<void> Function() op) {
    final Future<void> next = _audioOps
        .then((_) => op())
        .catchError((Object _) {});
    _audioOps = next;
    return next;
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
        _pausePlayback();
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
    double dt = (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;

    if (dt <= 0) return;
    if (dt > _maxTickDelta) dt = _maxTickDelta;

    if (_fanSpeed < _targetSpeed) {
      _fanSpeed = math.min(_targetSpeed, _fanSpeed + _accel * dt);
    } else if (_fanSpeed > _targetSpeed) {
      _fanSpeed = math.max(_targetSpeed, _fanSpeed - _accel * dt);
    }

    _fanAngle.value -= _fanSpeed * dt; // negative keeps the spin direction

    final bool holding = _fadeTarget > 0 && !_audioReady;

    if (!holding && _fadeLevel != _fadeTarget) {
      _fadeLevel = _fadeLevel < _fadeTarget
          ? math.min(_fadeTarget, _fadeLevel + _fadeRate * dt)
          : math.max(_fadeTarget, _fadeLevel - _fadeRate * dt);
      _applyVolume();

      if (_fadeLevel == _fadeTarget) {
        _fadeWatchdog?.cancel();
        _fadeWatchdog = null;
      }
    }

    if (_stopPending && _fadeLevel == 0) {
      _completeStop(); // clears _stopPending synchronously
    }

    if (_fanSpeed == 0 &&
        _targetSpeed == 0 &&
        _fadeLevel == _fadeTarget &&
        !_stopPending &&
        !holding) {
      _ticker.stop();
    }
  }

  void _ensureTicking() {
    if (!_ticker.isActive) {
      _lastTick = Duration.zero;
      _ticker.start();
    }
  }

  void _startSpin() {
    _targetSpeed = _maxFanSpeed;
    _ensureTicking();
  }

  void _stopSpin() {
    _targetSpeed = 0;
  }

  void _beginFade(double target, double seconds) {
    _fadeTarget = target;
    _fadeRate = 1 / seconds;
    _ensureTicking();
    _armFadeWatchdog();
  }

  double _volumeForLevel(double t) {
    if (t <= 0) return 0;
    if (t >= 1) return 1;
    return math.pow(10, (_fadeFloorDb * (1 - t)) / 20).toDouble();
  }

  void _applyVolume() {
    final int step = (_fadeLevel * _volumeSteps).round();
    if (step == _pushedStep) return;
    _pushedStep = step;

    final double volume = _volumeForLevel(step / _volumeSteps);
    unawaited(player.setVolume(volume).catchError((Object _) {}));
  }

  void _armFadeWatchdog() {
    // edge case for when user tabs out of the app
    _fadeWatchdog?.cancel();
    _fadeWatchdog = null;

    if (_fadeTarget > 0 && !_audioReady) return; // re-armed once the load lands
    if (_fadeLevel == _fadeTarget) return;

    final int ms = (((_fadeTarget - _fadeLevel).abs() / _fadeRate) * 1000)
        .ceil();
    _fadeWatchdog = Timer(Duration(milliseconds: ms + 500), _forceCompleteFade);
  }

  void _forceCompleteFade() {
    _fadeWatchdog = null;

    if (_fadeTarget > 0 && !_audioReady) return;
    if (_fadeLevel == _fadeTarget && !_stopPending) return;

    _fadeLevel = _fadeTarget;
    _applyVolume();

    if (_fadeLevel == 0 && _stopPending) _completeStop();
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
    _fadeWatchdog?.cancel();
    _playToken++; // abandon in-flight loads and the deferred teardown
    _stopPending = false;
    player.stop(); // teardown cuts hard; no fade
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
                onPressed: _play,
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
