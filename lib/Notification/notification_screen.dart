
import 'package:flutter/material.dart';
import 'package:nileshapp/Notification/notificationpill.dart';
import 'package:nileshapp/Notification/segmentedpill_button.dart';
import 'package:nileshapp/Notification/teaminvetation_card.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB); 
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
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
                  _buildTitleAndFilter(),
                  const SizedBox(height: 16),
                  _buildNotificationList(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        // Bell Icon
        Icon(
          Icons.notifications_none_rounded,
          color: Colors.white,
          size: 30,
        ),
        // Placeholder for a possible profile icon or menu
        SizedBox.shrink(),
      ],
    );
  }

  Widget _buildTitleAndFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,

          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SegmentedPillButton(label: 'Projects', isSelected: true, activeColor: kAccentTeal),
                SegmentedPillButton(label: 'Payments', isSelected: true, activeColor: kAccentPink),
                SegmentedPillButton(label: 'System', isSelected: true, activeColor: kPrimaryPurple),
              ],
            ),
            SizedBox(height: 8),
            const Text(
              'Mark all as read',
              style: TextStyle(color: kTextSecondary, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationList() {
    return Column(
      children: [
        // 1. Team Invitation Card (Special highlighted item)
        const TeamInvitationCard(),

        // 2. Payment Notification
        NotificationPill(
          icon: Icons.monetization_on_rounded,
          iconColor: kAccentTeal,
          title: 'Payment of 750 received',
          subtitle: 'from Starlight Studio',
        ),

        // 3. Project Deadline Notification
        NotificationPill(
          icon: Icons.calendar_today_rounded,
          iconColor: kAccentPink,
          title: 'Project "Redesign UI" deadline',
          subtitle: 'approaching',
        ),

        // 4. System Update Notification
        NotificationPill(
          icon: Icons.settings_rounded,
          iconColor: kPrimaryPurple,
          title: 'Platform update: New AI tools',
          subtitle: 'available',
        ),
      ],
    );
  }
}
