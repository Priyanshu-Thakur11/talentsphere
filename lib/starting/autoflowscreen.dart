import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nileshapp/starting/forgot_screen.dart';
import 'package:nileshapp/starting/login_screen.dart';
import 'package:nileshapp/starting/onboarding_screen.dart';
import 'package:nileshapp/starting/register_screen.dart';
import 'package:nileshapp/providers/auth_provider.dart';
import 'package:nileshapp/main.dart';


const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB); 
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;

enum AuthScreen { onboarding, login, register, forgotPassword }

class AuthFlowScreen extends StatefulWidget {
  const AuthFlowScreen({super.key});

  @override
  State<AuthFlowScreen> createState() => _AuthFlowScreenState();
}

class _AuthFlowScreenState extends State<AuthFlowScreen> {
  AuthScreen currentScreen = AuthScreen.onboarding; // Start with Onboarding

  void navigateTo(AuthScreen screen) {
    setState(() {
      currentScreen = screen;
    });
  }

  void _navigateToMainApp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Check if user is authenticated
        if (authProvider.isAuthenticated) {
          // User is logged in, navigate to main app
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _navigateToMainApp();
          });
          return const Scaffold(
            backgroundColor: kDarkBackground,
            body: Center(
              child: CircularProgressIndicator(
                color: kPrimaryPurple,
              ),
            ),
          );
        }

        // User is not authenticated, show auth screens
        Widget activeScreen;

        switch (currentScreen) {
          case AuthScreen.onboarding:
            activeScreen = OnboardingScreen(onGetStarted: () => navigateTo(AuthScreen.login));
            break;
          case AuthScreen.login:
            activeScreen = LoginScreen(
              onSignUp: () => navigateTo(AuthScreen.register),
              onForgotPassword: () => navigateTo(AuthScreen.forgotPassword),
            );
            break;
          case AuthScreen.register:
            activeScreen = RegisterScreen(
              onLogin: () => navigateTo(AuthScreen.login),
            );
            break;
          case AuthScreen.forgotPassword:
            activeScreen = ForgotPasswordScreen(
              onLogin: () => navigateTo(AuthScreen.login),
            );
            break;
        }

        return activeScreen;
      },
    );
  }
}
