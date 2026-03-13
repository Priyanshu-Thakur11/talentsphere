import 'package:flutter/material.dart';
import 'package:nileshapp/Payment/trasaction_iteam.dart';

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

class TransactionHistoryView extends StatelessWidget {
  const TransactionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Transaction',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          // Sample Transactions
          TransactionItem(
            recipient: 'Payment to Priya Sharma',
            project: 'Website Redergn & Dev',
            amount: '-2,750.00',
            date: 'Oct 20',
            isCredit: false,
          ),
          TransactionItem(
            recipient: 'Payment to Rajash Gupta',
            project: 'Website Redergn & Dev',
            amount: '-1,500.00',
            date: 'Oct 10',
            isCredit: false,
          ),
          TransactionItem(
            recipient: 'Payment to Rajash Gupta',
            project: 'Mobile App UI/UX',
            amount: '-1,500.00',
            date: 'Oct 15',
            isCredit: false,
          ),
          TransactionItem(
            recipient: 'Deposit from Bank',
            project: 'Mobile App UI/UX',
            amount: '+5,000.00',
            date: 'Oct 20',
            isCredit: true,
          ),
        ],
      ),
    );
  }
}