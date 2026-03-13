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
class ImplementAuthTaskCard extends StatelessWidget {
  const ImplementAuthTaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    // This card is complexly positioned, so we'll wrap it in a Positioned widget
    // for a Stack-based layout, mimicking the original image's floating effect.
    return Transform.translate(
      offset: const Offset(50, -100), // Offsetting it to look like it's floating relative to the previous card
      child: Transform.rotate(
        angle: 0.05, // Slight rotation for floating effect
        child: Container(
          width: 500 * 0.9, // Slightly smaller width
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kAccentTeal,
            borderRadius: BorderRadius.circular(kCardRadius - 5),
            boxShadow: [
              BoxShadow(
                color: kPrimaryPurple.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Implement User Authentication',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
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
                  Container(
                    width: 18, height: 18,
                    decoration: BoxDecoration(
                      color: kAccentTeal.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: kAccentTeal.withOpacity(0.5)),
                    ),
                    child: Center(child: Text('2', style: TextStyle(color: kAccentTeal, fontSize: 10, fontWeight: FontWeight.bold))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
