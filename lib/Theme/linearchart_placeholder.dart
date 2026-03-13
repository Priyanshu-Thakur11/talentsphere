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
class LineChartPlaceholder extends StatelessWidget {
  const LineChartPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [kAccentPink.withOpacity(0.1), kPrimaryPurple.withOpacity(0.1)],
        ),
      ),
      // Simple representation of the line chart using a gradient and a few dots
      child: Stack(
        children: [
          // Line simulation
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kAccentPink, kPrimaryPurple, kAccentTeal],
                ),
                boxShadow: [
                  BoxShadow(
                    color: kAccentPink.withOpacity(0.6),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
          ),
          // Dots simulation
          ...List.generate(5, (index) {
            return Positioned(
              left: 30.0 + (index * 60.0),
              bottom: 10.0 + (index % 2 == 0 ? 30.0 : 50.0),
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: kAccentPink.withOpacity(0.8),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
