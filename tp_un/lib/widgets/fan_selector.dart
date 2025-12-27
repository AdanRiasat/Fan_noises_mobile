import 'package:flutter/material.dart';

class FanOption extends StatelessWidget {
  final String label;
  final bool selected;

  const FanOption({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF59556F)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: selected ? Colors.white : Colors.white70),
      ),
    );
  }
}
