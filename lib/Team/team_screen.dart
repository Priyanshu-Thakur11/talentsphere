import 'package:flutter/material.dart';
import 'package:nileshapp/Team/team_card.dart';
import 'package:nileshapp/Theme/actionpill_button.dart';
import 'package:nileshapp/Theme/aiteamsuggestion_card.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB); 
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;
class TeamsScreen extends StatelessWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Custom Background (simulating the depth and glow)
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.6),
                radius: 1.5,
                colors: [
                  Color(0xFF1E1436), // Dark center glow
                  kDarkBackground,
                ],
              ),
            ),
          ),

          // Main Scrollable Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('My Teams'),
                  const SizedBox(height: 16),
                  _buildMyTeamsList(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('AI Team Suggestions'),
                  const SizedBox(height: 16),
                  _buildAITeamSuggestions(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

  // --- Widget Builders ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'Teams',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(
          Icons.menu_rounded,
          color: Colors.white,
          size: 30,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Create Team Button (Gradient Background)
        ActionPillButton(
          label: 'Create Team',
          icon: Icons.add_rounded,
          backgroundColor: kAccentTeal.withOpacity(0.2),
          textColor: kAccentTeal,
          glowColor: kAccentTeal,
        ),
        const SizedBox(width: 12),
        // AI Team Suggestions Button (Dark Background)
        ActionPillButton(
          label: 'AI Team Suggestions',
          backgroundColor: kCardColor,
          textColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildMyTeamsList() {
    // Placeholder URLs for member avatars
    const avatar1 = 'https://wallpapers.com/images/hd/cool-profile-picture-ld8f4n1qemczkrig.jpg';
    const avatar2 = 'https://image.lexica.art/full_jpg/8f87cbeb-233e-42b7-9822-241444d591b1';
    const avatar3 = 'https://wallpapers.com/images/hd/best-profile-pictures-7c4fnz0x5hts559b.jpg';

    return Column(
      children: [
        // Nexus Corp Card (Simple layout)
        const TeamCard(
          teamName: 'Nexus Corp',
          teamIcon: Icons.link_rounded,
          iconColor: kAccentTeal,
          memberAvatars: [],
          subtextLeft: 'Joint Portfolio',
          subtextRight: 'Revenue Share',
        ),
        // Starlight Studio Card (With Avatars)
        TeamCard(
          teamName: 'Starlight Studio',
          teamIcon: Icons.psychology_rounded,
          iconColor: kPrimaryPurple,
          memberAvatars: const [avatar1, avatar2, avatar3],
        ),
      ],
    );
  }

  Widget _buildAITeamSuggestions() {
    return const Column(
      children: [
        // AI Team Suggestion Card (With percentage and invite button)
        AITeamSuggestionCard(
          teamName: 'Cosmic Labs',
          teamIcon: Icons.star_rounded,
          iconColor: kAccentTeal,
          matchPercentage: 92,
          rolesNeeded: 'UI/UX, Dev',
        ),
        // You would add more suggestions here
        AITeamSuggestionCard(
          teamName: 'Starlight Studio',
          teamIcon: Icons.psychology_rounded,
          iconColor: kAccentPink,
          matchPercentage: 85,
          rolesNeeded: 'Copywriter, PM',
        )
      ],
    );
  }