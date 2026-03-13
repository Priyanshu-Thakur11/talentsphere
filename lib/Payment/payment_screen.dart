import 'package:flutter/material.dart';
import 'package:nileshapp/Payment/allmilestoneview.dart';
import 'package:nileshapp/Payment/milestone_view.dart';
import 'package:nileshapp/Payment/payment_tab.dart';
import 'package:nileshapp/Payment/paymentmet_view.dart';

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
class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = [
    'All Milestones',
    'Transaction History',
    'Payment Methods',
  ];

  @override
  void initState() {
    super.initState();
    // Default to the first tab (All Milestones)
    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Custom Background (simulating the depth and glow)
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

          // Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildTabBar(),
                // Use IndexedStack to only build the visible tab, but TabBarView is easier for basic switching
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      AllMilestonesView(),
                      TransactionHistoryView(),
                      PaymentMethodsView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 10), // Space below status bar
          Text(
            'Payments & Milestones',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // Tab Bar container to wrap the tabs
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorPadding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.transparent, width: 0), // Hide default indicator
        ),
        onTap: (index) {
          setState(() {});
        },
        tabs: _tabs.asMap().entries.map((entry) {
          int index = entry.key;
          String label = entry.value;
          return PaymentsTab(
            label: label,
            isActive: _tabController.index == index,
          );
        }).toList(),
      ),
    );
  }
}
