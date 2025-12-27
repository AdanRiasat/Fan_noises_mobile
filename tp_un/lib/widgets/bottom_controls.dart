import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:tp_un/widgets/fan_selector.dart';
import 'package:tp_un/widgets/speed_button.dart';
import 'package:tp_un/widgets/timer_button.dart';

class BottomControls extends StatefulWidget {
  const BottomControls({super.key});

  @override
  State<BottomControls> createState() => _BottomControlsState();
}

class _BottomControlsState extends State<BottomControls> {
  double? _volume;

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
              FanOption(label: "Fan xyz72 mini", selected: true),
              FanOption(label: "Personal fan"),
              FanOption(label: "Fan 32"),
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
                    SpeedButton("LO"),
                    SizedBox(width: 12),
                    SpeedButton("MED", selected: true),
                    SizedBox(width: 12),
                    SpeedButton("HI"),
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
