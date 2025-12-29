import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:tp_un/db/fan.dart';
import 'package:tp_un/db/fan_controller.dart';
import 'package:tp_un/db/fan_speed.dart';
import 'package:tp_un/widgets/fan_option.dart';
import 'package:tp_un/widgets/speed_button.dart';
import 'package:tp_un/widgets/timer_button.dart';

class BottomControls extends StatefulWidget {
  final ValueChanged<String> onFanSelected;

  const BottomControls({super.key, required this.onFanSelected});

  @override
  State<BottomControls> createState() => _BottomControlsState();
}

class _BottomControlsState extends State<BottomControls> {
  List<Fan> _fans = [];
  Fan? _selectedFan;

  int _speedIndex = FanSpeed.medium;

  double? _volume;

  Future<List<Fan>> _loadFans() async {
    return await FanController.instance.getFans();
  }

  void _selectFan(Fan fan) {
    setState(() {
      _selectedFan = fan;
    });

    _updateAudio();
  }

  void _onSpeedChanged(int speedIndex) {
    setState(() {
      _speedIndex = speedIndex;
    });

    _updateAudio();
  }

  void _updateAudio() {
    if (_selectedFan == null) return;

    final audioPaths = _selectedFan!.audioPaths;

    if (_speedIndex < 0 || _speedIndex >= audioPaths.length) return;

    widget.onFanSelected(audioPaths[_speedIndex]);
  }

  Future<double?> _getVolume() async {
    return await FlutterVolumeController.getVolume();
  }

  void _onVolumeChanged(double volume) {
    setState(() {
      _volume = volume;
    });
  }

  @override
  void initState() {
    super.initState();

    _getVolume().then((volume) {
      setState(() {
        _volume = volume;
      });
    });

    _loadFans().then((fans) {
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
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E26),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fan selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.chevron_left, color: Colors.white54),

              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
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

              Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),

          const SizedBox(height: 25),

          Column(
            spacing: 12,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.directional(start: 31, end: 31),
                child: Row(
                  children: [
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
                          ? "Vol: --"
                          : "Vol: ${(_volume! * 100).round()}%",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsetsGeometry.directional(start: 31, end: 31),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 12,
                  children: [
                    TimerButton("Set timer"),
                    Text(
                      "Timer: 30:00:00",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // Timer row
            ],
          ),

          // Speed buttons
        ],
      ),
    );
  }
}
