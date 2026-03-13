import 'package:flutter/material.dart';
import 'package:nileshapp/Payment/milestone.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB);
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);
const Color kSuccessGreen = Color(0xFF20C9A5);
const Color kErrorRed = Color(0xFFFF4D4D);
const Color kReleaseBlue = Color(0xFF00C9FF); // Brighter blue for Release button

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;

class AllMilestonesView extends StatelessWidget {
  const AllMilestonesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'All Milestones',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kCardColor,
              borderRadius: BorderRadius.circular(kCardRadius),
              border: Border.all(color: kPrimaryPurple.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                // Header Row
                MilestoneRow(
                  name: 'Milestone name',
                  amount: 'Amount',
                  dueDate: 'Due date',
                  status: 'Status',
                ),
                const Divider(color: kTextSecondary, height: 1, thickness: 0.2),
                // Data Rows
                MilestoneRow(
                  name: 'Pending',
                  amount: '3,000.00',
                  dueDate: 'Released',
                  status: 'Released',
                ),
                MilestoneRow(
                  name: 'Pending',
                  amount: '1,500.00',
                  dueDate: 'Release',
                  status: 'ReleaseButton',
                ),
                MilestoneRow(
                  name: 'Released',
                  amount: '500.00',
                  dueDate: 'Cancelled',
                  status: 'Cancelled',
                ),
                MilestoneRow(
                  name: 'Gosuk',
                  amount: '2,000.00',
                  dueDate: 'Released',
                  status: 'Released',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Add New Milestone Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: kCardColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: kAccentTeal.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_circle, color: kAccentTeal, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Add New Milestone',
                  style: TextStyle(color: kAccentTeal, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Auto Release Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Auto Release',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  Text(
                    'on Approval',
                    style: TextStyle(color: kTextSecondary, fontSize: 13),
                  ),
                ],
              ),
              Switch(
                value: true,
                onChanged: (val) {},
                activeColor: kAccentTeal,
                inactiveThumbColor: kTextSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

