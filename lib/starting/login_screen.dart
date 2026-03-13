import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nileshapp/ClientDashborad/DashboardScreen.dart';
import 'package:nileshapp/admindashboard/adminscreen.dart';
import 'package:nileshapp/main.dart';
import 'package:nileshapp/starting/customtext_field.dart';
import 'package:nileshapp/starting/gradientbutton.dart';
import 'package:nileshapp/providers/auth_provider.dart';
import 'package:nileshapp/models/user_model.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB);
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);
const Color kGlowBlue = Color(0xFF00B4D8);

const double kCardRadius = 20.0;

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final VoidCallback onSignUp;
  final VoidCallback onForgotPassword;

  LoginScreen({
    super.key,
    required this.onSignUp,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      body: Stack(
        children: [
          // Background Glow
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAuthTabs(context),
                  const SizedBox(height: 30),

                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email & Password Fields
                  CustomTextField(
                    Controller: emailController,
                    label: 'Email',
                    prefixIcon: Icons.email_rounded,
                  ),
                  CustomTextField(
                    Controller: passwordController,
                    label: 'Password',
                    prefixIcon: Icons.lock_rounded,
                    obscureText: true,
                    suffixIcon:
                        const Icon(Icons.remove_red_eye_outlined, color: kTextSecondary),
                  ),

                  // Forgot Password
                  GestureDetector(
                    onTap: onForgotPassword,
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: kTextSecondary, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Login Button
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return GradientButton(
                        text: authProvider.isLoading ? 'Signing In...' : 'Login',
                        onPressed: authProvider.isLoading ? null : () {
                          if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();

                            // Handle special admin login
                            if (email == "admin@123" && password == "admin@123") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const MainDashboard()),
                              );
                              return;
                            }

                            // Handle special client login
                            if (email == "owner" || authProvider.userModel?.role == UserRole.client) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const ClientDashboardScreen()),
                              );
                              return;
                            }

                            // Regular authentication
                            authProvider.signIn(
                              email: email,
                              password: password,
                            ).then((success) {
                              if (success && context.mounted) {
                              // Navigate based on user role
                              final userModel = authProvider.userModel;
                              if (userModel != null) {
                                switch (userModel.role) {
                                  case UserRole.admin:
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const MainDashboard()),
                                    );
                                    break;
                                  case UserRole.client:
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ClientDashboardScreen()),
                                    );
                                    break;
                                  case UserRole.freelancer:
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const MainScreen()),
                                    );
                                    break;
                                }
                              }
                              } else if (authProvider.error != null && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(authProvider.error!),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            });

                            // Clear text fields after login
                            emailController.clear();
                            passwordController.clear();
                          }
                        },
                        colors: const [kAccentTeal, kGlowBlue],
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // OR Continue With
                  const Center(
                    child: Text(
                      'OR Continue with',
                      style: TextStyle(color: kTextSecondary, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildGoogleSignInButton(),
                  const SizedBox(height: 50),

                  // Sign Up Link
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: kTextSecondary, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: onSignUp,
                          child: const Text(
                            ' Sign Up',
                            style: TextStyle(
                              color: kPrimaryPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  // --- Auth Tabs (Login/SignUp) ---
  Widget _buildAuthTabs(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [kAccentTeal, kGlowBlue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'Login',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onSignUp,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: kTextSecondary.withOpacity(0.8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Google Sign-In Button ---
  Widget _buildGoogleSignInButton() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      child: TextButton(
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/2991/2991148.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Continue with Google',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
