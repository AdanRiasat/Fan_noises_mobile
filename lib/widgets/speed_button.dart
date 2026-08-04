import 'package:flutter/material.dart';

class SpeedButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SpeedButton({
    super.key,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF59556F)
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: TextStyle(color: selected ? Colors.white : Colors.white70),
          ),
        ),
      ),
    );
  }
}
