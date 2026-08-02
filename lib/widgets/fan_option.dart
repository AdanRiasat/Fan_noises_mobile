import 'package:flutter/material.dart';
import 'package:fan_noises/db/fan.dart';

class FanOption extends StatelessWidget {
  final Fan fan;
  final bool selected;
  final ValueChanged<Fan> onSelected;

  const FanOption({
    super.key,
    required this.fan,
    required this.onSelected,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => {onSelected(fan)},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF59556F)
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            fan.name,
            style: TextStyle(color: selected ? Colors.white : Colors.white70),
          ),
        ),
      ),
    );
  }
}
