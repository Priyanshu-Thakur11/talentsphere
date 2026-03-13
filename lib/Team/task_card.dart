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
const double kTaskColumnWidth = 250.0; // ✅ Increased width to prevent overflow

class TaskCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final double? progress;

  const TaskCard({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kTaskColumnWidth, // ✅ Safe width
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: kPrimaryPurple.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: kPrimaryPurple.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor?.withOpacity(0.1) ?? kPrimaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: iconColor?.withOpacity(0.5) ?? kPrimaryPurple.withOpacity(0.5),
                  ),
                ),
                child: Center(
                  child: icon != null
                      ? Icon(icon, color: iconColor ?? kPrimaryPurple, size: 24)
                      : const Icon(Icons.check_box_outline_blank, color: kTextSecondary, size: 20),
                ),
              ),
              const SizedBox(width: 12),

              // ✅ Expanded Title to wrap neatly
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // ✅ Menu icon with flexible space
              const SizedBox(width: 4),
              Icon(Icons.more_vert_rounded, color: kTextSecondary, size: 20),
            ],
          ),

          // ✅ Optional progress bar section
          if (progress != null) ...[
            const SizedBox(height: 12),
            Text(
              '${(progress! * 100).toInt()}%',
              style: const TextStyle(color: kTextSecondary, fontSize: 13),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progress!,
              backgroundColor: kCardColor,
              valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryPurple),
              minHeight: 5,
              borderRadius: BorderRadius.circular(5),
            ),
          ],
        ],
      ),
    );
  }
}
