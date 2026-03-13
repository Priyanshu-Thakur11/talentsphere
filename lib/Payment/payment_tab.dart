import 'package:flutter/material.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB);
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);
const Color kSuccessGreen = Color(0xFF20C9A5);
const Color kErrorRed = Color(0xFFFF4D4D);
const Color kReleaseBlue = Color(0xFF00C9FF); // Brighter blue for Release button

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;
class PaymentsTab extends StatelessWidget {
  final String label;
  final bool isActive;

  const PaymentsTab({
    super.key,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      margin: const EdgeInsets.only(right: 8),
      decoration: isActive
          ? BoxDecoration(
              gradient: LinearGradient(
                colors: [kAccentTeal.withOpacity(0.8), kAccentPink.withOpacity(0.8)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            )
          : null,
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : kTextSecondary.withOpacity(0.8),
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}