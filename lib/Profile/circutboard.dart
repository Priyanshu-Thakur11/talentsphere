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

class CircuitBoardBackground extends StatelessWidget {
  const CircuitBoardBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250, // Height of the header section
      decoration: BoxDecoration(
        color: kDarkBackground,
        // Mock circuit pattern effect
        image: DecorationImage(
          image: NetworkImage('https://wallpapers.com/images/hd/best-profile-pictures-7c4fnz0x5hts559b.jpg'), // Placeholder for the circuit image
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Simulated glow layers (Teal & Pink)
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 150, height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: kAccentTeal.withOpacity(0.4), blurRadius: 40, spreadRadius: 5),
                  BoxShadow(color: kAccentPink.withOpacity(0.4), blurRadius: 40, spreadRadius: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
