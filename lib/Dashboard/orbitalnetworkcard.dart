
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


class OrbitalNetworkCard extends StatelessWidget {
  final String title;
  final Color color;

  const OrbitalNetworkCard({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: kGlowSpread,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for the "Orbital Network" image/art
          Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.5), kCardColor.withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'AI',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const Text(
            'Lorem ipsum obsenic etonited and boened danostripso roornboited obnm tinars.',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: kTextSecondary, fontSize: 10),
          ),
        ],
      ),
    );
  }
}