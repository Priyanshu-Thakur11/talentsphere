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

class TransactionItem extends StatelessWidget {
  final String recipient;
  final String project;
  final String amount;
  final String date;
  final bool isCredit;

  const TransactionItem({
    super.key,
    required this.recipient,
    required this.project,
    required this.amount,
    required this.date,
    required this.isCredit,
  });

  @override
  Widget build(BuildContext context) {
    final amountColor = isCredit ? kSuccessGreen : kErrorRed;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kCardColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kTextSecondary.withOpacity(0.2)),
            ),
            child: Center(
              child: Icon(
                isCredit ? Icons.account_balance : Icons.person,
                color: kTextSecondary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipient,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Text(
                  'Project: $project',
                  style: TextStyle(color: kTextSecondary, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'Date $date, 2023',
                  style: TextStyle(color: kTextSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(color: amountColor, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Completed',
                    style: TextStyle(color: kSuccessGreen, fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.check_circle, color: kSuccessGreen, size: 16),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}