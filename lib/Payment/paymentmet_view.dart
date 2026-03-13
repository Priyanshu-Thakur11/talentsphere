
import 'package:flutter/material.dart';
import 'package:nileshapp/Payment/paymentmethod_tab.dart';

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

class PaymentMethodsView extends StatelessWidget {
  const PaymentMethodsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Methods',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          // Card 1
          const PaymentMethodCard(
            cardType: 'Visa',
            lastFour: '1234',
            label: 'Primary',
            expiry: '11/25',
            glowColor: kAccentTeal,
          ),
          // Card 2
          const PaymentMethodCard(
            cardType: 'Master',
            lastFour: '5678',
            label: 'Cothard',
            expiry: '12/25',
            glowColor: kAccentPink,
          ),
          const SizedBox(height: 24),
          // Add New Method Button
          Container(
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kAccentTeal.withOpacity(0.8), kPrimaryPurple.withOpacity(0.8)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Add New Method',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}