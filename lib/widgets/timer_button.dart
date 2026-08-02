import 'package:flutter/material.dart';
import 'package:fan_noises/widgets/timer_picker.dart';

class TimerButton extends StatelessWidget {
  final String text;
  final ValueChanged<Duration> onSelected;

  const TimerButton(this.text, this.onSelected, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () async {
          final duration = await showModalBottomSheet<Duration>(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => TimerPicker(),
          );

          onSelected(duration ?? Duration.zero);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF59556F)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
