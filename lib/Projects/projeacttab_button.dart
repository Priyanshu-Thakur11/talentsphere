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

class ProjectTabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap; // 👈 Add this

  const ProjectTabButton({
    super.key,
    required this.label,
    required this.isActive,
    this.onTap, // 👈 Include this in constructor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 👈 Add gesture detection
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : kTextSecondary.withOpacity(0.6),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            if (isActive)
              Container(
                height: 3,
                width: 30,
                decoration: BoxDecoration(
                  color: kAccentTeal,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: kAccentTeal.withOpacity(0.5),
                      blurRadius: 5,
                    ),
                  ],
                ),
              )
            else
              const SizedBox(height: 3),
          ],
        ),
      ),
    );
  }
}
