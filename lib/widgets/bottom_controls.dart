import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:fan_noises/db/fan.dart';
import 'package:fan_noises/db/fan_controller.dart';
import 'package:fan_noises/db/fan_speed.dart';
import 'package:fan_noises/themes/app.theme.dart';
import 'package:fan_noises/widgets/fan_option.dart';
import 'package:fan_noises/widgets/speed_button.dart';
import 'package:fan_noises/widgets/timer_button.dart';
import '../generated/l10n.dart';

class BottomControls extends StatefulWidget {
  final ValueChanged<String> onFanSelected;
  final ValueChanged<bool> checkFanType;
  final ValueChanged<Duration> onTimerSelected;
  final Duration remainingDuration;

  const BottomControls({
    super.key,
    required this.onFanSelected,
    required this.checkFanType,
    required this.onTimerSelected,
    required this.remainingDuration,
  });

  @override
  State<BottomControls> createState() => _BottomControlsState();
}

class _BottomControlsState extends State<BottomControls> {
  List<Fan> _fans = [];
  Fan? _selectedFan;

  int _speedIndex = FanSpeed.medium;

  double? _volume;

  final ScrollController _scrollController = ScrollController();

  void _selectFan(Fan fan) {
    setState(() {
      _selectedFan = fan;
      _speedIndex = fan.isCustom ? 0 : FanSpeed.medium;
    });

    _updateAudio();
  }

  void _onSpeedChanged(int speedIndex) {
    setState(() {
      _speedIndex = speedIndex;
    });

    _updateAudio();
  }

  void _onVolumeChanged(double volume) {
    setState(() {
      _volume = volume;
    });
  }

  void _updateAudio() {
    if (_selectedFan == null) return;

    final audioPaths = _selectedFan!.audioPaths;

    if (_speedIndex < 0 || _speedIndex >= audioPaths.length) return;

    widget.onFanSelected(audioPaths[_speedIndex]);
    widget.checkFanType(_selectedFan!.isCustom);
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');

    final h = two(d.inHours);
    final m = two(d.inMinutes.remainder(60));
    final s = two(d.inSeconds.remainder(60));

    return "$h:$m:$s";
  }

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 200,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 200,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();

    FlutterVolumeController.getVolume().then((volume) {
      setState(() {
        _volume = volume;
      });
    });

    FanController.instance.getFans().then((fans) {
      setState(() {
        _fans = fans;
        if (_fans.isNotEmpty) {
          _selectFan(_fans[0]);
        }
      });
    });

    FlutterVolumeController.addListener(_onVolumeChanged);
  }

  @override
  void dispose() {
    FlutterVolumeController.removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(63, 59, 85, 0.12),
            blurRadius: 10,
            offset: const Offset(0, -8),
          ),
          BoxShadow(
            color: const Color.fromRGBO(63, 59, 85, 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fan selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: _scrollLeft,
                child: SizedBox(
                  width: 30,
                  child: Icon(Icons.chevron_left, color: AppTheme.primaryText),
                ),
              ),

              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: _fans.length,
                    itemBuilder: (context, index) {
                      final fan = _fans[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: FanOption(
                          fan: fan,
                          selected: _selectedFan?.id == fan.id,
                          onSelected: _selectFan,
                        ),
                      );
                    },
                  ),
                ),
              ),

              InkWell(
                onTap: _scrollRight,
                child: SizedBox(
                  width: 30,
                  child: Icon(Icons.chevron_right, color: AppTheme.primaryText),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          Column(
            spacing: 12,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.directional(start: 31, end: 31),
                child: Row(
                  children: _selectedFan != null
                      ? !_selectedFan!.isCustom
                            ? [
                                SpeedButton(
                                  label: "LO",
                                  selected: _speedIndex == FanSpeed.low,
                                  onTap: () => _onSpeedChanged(FanSpeed.low),
                                ),
                                SizedBox(width: 12),
                                SpeedButton(
                                  label: "MED",
                                  selected: _speedIndex == FanSpeed.medium,
                                  onTap: () => _onSpeedChanged(FanSpeed.medium),
                                ),
                                SizedBox(width: 12),
                                SpeedButton(
                                  label: "HI",
                                  selected: _speedIndex == FanSpeed.high,
                                  onTap: () => _onSpeedChanged(FanSpeed.high),
                                ),
                                SizedBox(width: 12),
                                Spacer(),
                                Text(
                                  _volume == null
                                      ? "${S.of(context).volumeLabel} --"
                                      : "${S.of(context).volumeLabel} ${(_volume! * 100).round()}%",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ]
                            : [
                                SpeedButton(
                                  label: "REG",
                                  selected: true,
                                  onTap: () {},
                                ),
                                Spacer(),
                                Text(
                                  _volume == null
                                      ? "${S.of(context).volumeLabel} --"
                                      : "${S.of(context).volumeLabel} ${(_volume! * 100).round()}%",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ]
                      : [],
                ),
              ),

              Padding(
                padding: EdgeInsetsGeometry.directional(start: 31, end: 31),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 12,
                  children: [
                    TimerButton(S.of(context).setTimer, widget.onTimerSelected),
                    Text(
                      "${S.of(context).timerLabel} ${_formatDuration(widget.remainingDuration)}",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Speed buttons
        ],
      ),
    );
  }
}
