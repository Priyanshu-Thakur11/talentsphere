import 'package:flutter/material.dart';

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

class MilestoneRow extends StatelessWidget {
  final String name;
  final String amount;
  final String dueDate;
  final String status;

  const MilestoneRow({
    super.key,
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.status,
  });

  Widget _buildStatus(String status) {
    Color color;
    Widget child;

    switch (status) {
      case 'Pending':
        color = kAccentTeal;
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, color: color, size: 12),
            const SizedBox(width: 4),
            Text(status, style: TextStyle(color: color, fontSize: 12)),
          ],
        );
        break;
      case 'Released':
        color = kSuccessGreen;
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, color: color, size: 12),
            const SizedBox(width: 4),
            Text(status, style: TextStyle(color: color, fontSize: 12)),
          ],
        );
        break;
      case 'Cancelled':
        color = kErrorRed;
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, color: color, size: 12),
            const SizedBox(width: 4),
            Text(status, style: TextStyle(color: color, fontSize: 12)),
          ],
        );
        break;
      case 'ReleaseButton':
        color = kReleaseBlue;
        child = Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Text('Release', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        );
        break;
      default:
        color = kTextSecondary;
        child = Text(status, style: TextStyle(color: color, fontSize: 12));
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Milestone name (25%)
          Expanded(flex: 3, child: _buildStatus(name == 'Pending' ? 'Pending' : name)), 
          // Amount (25%)
          Expanded(
            flex: 3,
            child: Text(
              amount,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          // Due date (25%)
          Expanded(
            flex: 3,
            child: Text(
              dueDate,
              style: TextStyle(color: kTextSecondary, fontSize: 12),
            ),
          ),
          // Status/Release Button (25%)
          Expanded(
            flex: 3,
            child: Align(alignment: Alignment.centerRight, child: _buildStatus(status)),
          ),
        ],
      ),
    );
  }
}
