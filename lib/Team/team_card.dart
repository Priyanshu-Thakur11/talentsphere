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
class TeamCard extends StatelessWidget {
  final String teamName;
  final IconData teamIcon;
  final Color iconColor;
  final List<String> memberAvatars;
  final String? subtextLeft;
  final String? subtextRight;

  const TeamCard({
    super.key,
    required this.teamName,
    required this.teamIcon,
    required this.iconColor,
    required this.memberAvatars,
    this.subtextLeft,
    this.subtextRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // Row 1: Team Icon and Name
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(teamIcon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teamName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    if (subtextLeft != null || subtextRight != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            subtextLeft ?? '',
                            style: TextStyle(color: kTextSecondary.withOpacity(0.8), fontSize: 13),
                          ),
                          Text(
                            subtextRight ?? '',
                            style: TextStyle(color: kTextSecondary.withOpacity(0.8), fontSize: 13),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          // Row 2: Member Avatars (for Starlight Studio)
          if (memberAvatars.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: memberAvatars.map((url) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundImage: NetworkImage(url),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}