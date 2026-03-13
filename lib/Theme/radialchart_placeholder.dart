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

class RadialChartPlaceholder extends StatelessWidget {
  const RadialChartPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    // This is a simplified visual representation of the complex circular indicators
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: 0.85, // 85%
            strokeWidth: 5,
            valueColor: AlwaysStoppedAnimation<Color>(kAccentTeal.withOpacity(0.5)),
            backgroundColor: kAccentTeal.withOpacity(0.1),
          ),
        ),
        SizedBox(
          width: 55,
          height: 55,
          child: CircularProgressIndicator(
            value: 0.60, // 60%
            strokeWidth: 5,
            valueColor: AlwaysStoppedAnimation<Color>(kAccentPink.withOpacity(0.7)),
            backgroundColor: kAccentPink.withOpacity(0.1),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('85%', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
}