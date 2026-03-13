import 'dart:ui'; // 👈 Needed for glass blur effect
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nileshapp/starting/customtext_field.dart';
import 'package:nileshapp/starting/gradientbutton.dart';
import 'package:nileshapp/providers/auth_provider.dart';
import 'package:nileshapp/models/user_model.dart';
import 'package:nileshapp/main.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB);
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;
class RegisterScreen extends StatefulWidget {
  final VoidCallback onLogin;

  const RegisterScreen({super.key, required this.onLogin});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String selectedRole = 'Freelancer';
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Handle sign up
  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showErrorSnackBar('Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Convert role string to UserRole enum
      UserRole role = selectedRole == 'Freelancer' 
          ? UserRole.freelancer 
          : UserRole.client;

      // Get auth provider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Create user account
      final success = await authProvider.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
        role: role,
      );

      if (success) {
        // Show success message
        _showSuccessSnackBar('Account created successfully!');

        // Clear form
        _clearForm();

        // Navigate to main app (user is now authenticated)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        _showErrorSnackBar(authProvider.error ?? 'Failed to create account');
      }
      
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Clear form fields
  void _clearForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  // Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Show success snackbar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Validate email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Validate password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Validate name
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tab Buttons (Login / Sign Up)
                  _buildAuthTabs(context),
                  const SizedBox(height: 30),
                  
                  const Text(
                    'Create your account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Form Fields
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'Full Name',
                          prefixIcon: Icons.person_rounded,
                          Controller: nameController,
                          validator: _validateName,
                          keyboardType: TextInputType.name,
                        ),
                        CustomTextField(
                          label: 'Email',
                          prefixIcon: Icons.email_rounded,
                          Controller: emailController,
                          validator: _validateEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        CustomTextField(
                          label: 'Password',
                          prefixIcon: Icons.lock_rounded,
                          obscureText: _obscurePassword,
                          Controller: passwordController,
                          validator: _validatePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: kTextSecondary,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        CustomTextField(
                          label: 'Confirm Password',
                          prefixIcon: Icons.lock_rounded,
                          obscureText: _obscureConfirmPassword,
                          Controller: confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                              color: kTextSecondary,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  
                  // Role Selection
                  _buildRoleSelection(),
                  const SizedBox(height: 40),

                  // Register Button
                  GradientButton(
                    text: _isLoading ? 'Creating Account...' : 'Register',
                    onPressed: _isLoading ? null : _handleSignUp,
                    colors: const [kPrimaryPurple, kAccentTeal],
                  ),

                  const SizedBox(height: 30),
                  
                  // Already have an account? Login
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(color: kTextSecondary, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: widget.onLogin,
                          child: Text(
                            ' Login',
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom Auth Tabs
  Widget _buildAuthTabs(BuildContext context) {
    return Row(
      children: [
        // Login Button (Inactive)
        GestureDetector(
          onTap: widget.onLogin,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Login',
              style: TextStyle(color: kTextSecondary.withOpacity(0.8), fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Sign Up Button (Active)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [kAccentTeal, kPrimaryPurple],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // Role Selection Toggle
  Widget _buildRoleSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRoleButton('Freelancer'),
        _buildRoleButton('Client'),
      ],
    );
  }

  Widget _buildRoleButton(String role) {
    final bool isActive = selectedRole == role;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isActive ? kCardColor : Colors.transparent,
          borderRadius: BorderRadius.circular(kCardRadius - 5),
          border: Border.all(
            color: isActive ? kAccentTeal : kTextSecondary.withOpacity(0.3),
            width: 1.5,
          ),
          gradient: isActive
              ? const LinearGradient(
                  colors: [kAccentTeal, kAccentTeal], // Solid color for active
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(
              role == 'Freelancer' ? Icons.person_add_alt_1 : Icons.business_center_rounded,
              color: isActive ? Colors.white : kTextSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              role,
              style: TextStyle(
                color: isActive ? Colors.white : kTextSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}