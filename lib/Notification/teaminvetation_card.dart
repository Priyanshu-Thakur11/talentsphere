
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

class TeamInvitationCard extends StatelessWidget {
  const TeamInvitationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: kPrimaryPurple.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: kPrimaryPurple.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: kGlowSpread,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for User Avatar
          const CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage('https://tse4.mm.bing.net/th/id/OIP.5iVyXqRtvCrgKhF5sYbAEAHaHs?pid=Api&P=0&h=180'),
            backgroundColor: kPrimaryPurple,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'New team invitation from',
                  style: TextStyle(color: kTextSecondary, fontSize: 13),
                ),
                Text(
                  'Nexus Corp',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: kPrimaryPurple,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Accept',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
