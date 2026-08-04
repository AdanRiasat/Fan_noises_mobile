import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fan_noises/themes/app.theme.dart';
import '../generated/l10n.dart';

class TimerPicker extends StatefulWidget {
  const TimerPicker({super.key});

  @override
  State<TimerPicker> createState() => _TimerPickerState();
}

class _TimerPickerState extends State<TimerPicker> {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  Widget _picker({
    required int count,
    required ValueChanged<int> onChanged,
    required FixedExtentScrollController controller,
  }) {
    return SizedBox(
      width: 80,
      height: 200,
      child: CupertinoPicker(
        scrollController: controller,
        itemExtent: 42,
        magnification: 1.1,
        useMagnifier: true,
        onSelectedItemChanged: onChanged,
        children: List.generate(
          count,
          (i) => Center(
            child: Text(
              i.toString().padLeft(2, '0'),
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).setTimer,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryText,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _picker(
                  count: 24,
                  onChanged: (v) => hours = v,
                  controller: FixedExtentScrollController(),
                ),
                const Text("h"),
                _picker(
                  count: 60,
                  controller: FixedExtentScrollController(),
                  onChanged: (v) => minutes = v,
                ),
                const Text("m"),
                _picker(
                  count: 60,
                  controller: FixedExtentScrollController(),
                  onChanged: (v) => seconds = v,
                ),
                const Text("s"),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondary,
                  ),
                  onPressed: () {
                    Navigator.pop(context, Duration.zero);
                  },
                  child: Text(
                    S.of(context).cancel,
                    style: TextStyle(color: AppTheme.primaryText),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondary,
                  ),
                  onPressed: () {
                    Navigator.pop(
                      context,
                      Duration(
                        hours: hours,
                        minutes: minutes,
                        seconds: seconds,
                      ),
                    );
                  },
                  child: Text(
                    S.of(context).confirm,
                    style: TextStyle(color: AppTheme.primaryText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
