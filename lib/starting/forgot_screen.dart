import 'dart:ui'; // 👈 Needed for glass blur effect

import 'package:flutter/material.dart';
import 'package:nileshapp/starting/customtext_field.dart';
import 'package:nileshapp/starting/gradientbutton.dart';
import 'package:nileshapp/starting/placeholder_screen.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB);
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;
const double kTaskColumnWidth = 240.0;

class ForgotPasswordScreen extends StatelessWidget {
  final VoidCallback onLogin;

  const ForgotPasswordScreen({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      body: Stack(
        children: [
          // Radial Glow Background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.6),
                radius: 1.5,
                colors: [
                  Color(0xFF1E1436),
                  kDarkBackground,
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Illustration Placeholder
                  const PlaceholderImage(assetKey: 'forgot_password', size: 200),
                  const SizedBox(height: 40),
                  
                  const Text(
                    'Forgot Password?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Enter the email associated with your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kTextSecondary, fontSize: 16),
                  ),
                  const SizedBox(height: 30),

                  // Email Field
                  const CustomTextField(
                    label: 'Email Address',
                    prefixIcon: Icons.mail_rounded,
                  ),
                  
                  // Send Reset Link Button
                  GradientButton(
                    text: 'Send Reset Link',
                    onPressed: () {},
                    colors: const [kAccentTeal, kGlowBlue],
                  ),
                  const SizedBox(height: 30),

                  // Success Message (Mock)
                  _buildSuccessMessage(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: kAccentTeal.withOpacity(0.8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: kAccentTeal, size: 20),
          const SizedBox(width: 8),
          Text(
            'Reset link sent successfully!',
            style: TextStyle(color: kAccentTeal, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
