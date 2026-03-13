import 'package:flutter/material.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB); 
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;

class CustomTag extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final Widget? trailing;
  final double fontSize;

  const CustomTag({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor = kCardColor,
    this.textColor = Colors.white,
    this.trailing,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kTextSecondary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor, size: fontSize + 2),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: fontSize,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 6),
            trailing!,
          ],
        ],
      ),
    );
  }
}