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
class PlaceholderImage extends StatelessWidget {
  final String assetKey;
  final double size;

  const PlaceholderImage({super.key, required this.assetKey, required this.size});

  @override
  Widget build(BuildContext context) {
    // This widget simulates the complex, glowing illustrations using a placeholder.
    // In a real app, this would be an SVG or PNG asset.
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kCardColor.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
            color: kPrimaryPurple.withOpacity(0.4),
            blurRadius: 40,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: kAccentTeal.withOpacity(0.4),
            blurRadius: 40,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          _getIconForAsset(assetKey),
          color: Colors.white,
          size: size * 0.4,
        ),
      ),
    );
  }

  IconData _getIconForAsset(String key) {
    switch (key) {
      case 'ai_matchmaking':
        return Icons.psychology;
      case 'hire_join_teams':
        return Icons.groups;
      case 'collaborate':
        return Icons.chat_bubble_outline;
      case 'forgot_password':
        return Icons.mail_lock_rounded;
      default:
        return Icons.image;
    }
  }
}
