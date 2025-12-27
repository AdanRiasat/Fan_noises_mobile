import 'package:flutter/material.dart';

class SpeedButton extends StatelessWidget {
  final String label;
  final bool selected;

  const SpeedButton(this.label, {this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF59556F)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(color: selected ? Colors.white : Colors.white70),
      ),
    );
  }
}
