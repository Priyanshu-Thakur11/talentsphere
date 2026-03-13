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
class FloatingTaskCard extends StatelessWidget {
  final String title;

  const FloatingTaskCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // This card is a simplified representation of the complex layered card shown in the image.
    return Transform.translate(
      offset: const Offset(40, -100), // Offsetting it to look like it's floating
      child: Transform.rotate(
        angle: 0.1, // Slight rotation for floating effect
        child: Container(
          width: 250,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kCardColor,
            borderRadius: BorderRadius.circular(kCardRadius - 5),
            boxShadow: [
              BoxShadow(
                color: kPrimaryPurple.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const CircleAvatar(radius: 10, backgroundImage: NetworkImage('https://placehold.co/100x100/A3C2F7/FFFFFF?text=A')),
                  const SizedBox(width: 4),
                  const CircleAvatar(radius: 10, backgroundImage: NetworkImage('https://placehold.co/100x100/F7A3C2/FFFFFF?text=B')),
                  const Spacer(),
                  Icon(Icons.chat_bubble_outline, color: kTextSecondary, size: 16),
                  const SizedBox(width: 8),
                  Icon(Icons.calendar_month, color: kTextSecondary, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}