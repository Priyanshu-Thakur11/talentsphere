import 'package:flutter/material.dart';
import 'package:nileshapp/Community/community_screen.dart';
import 'package:nileshapp/Dashboard/dashboard_screen.dart';
import 'package:nileshapp/Payment/payment_screen.dart';
import 'package:nileshapp/Projects/project_screen.dart';
import 'package:nileshapp/Theme/customnavigator_bar.dart';


const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB); 
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => NavigationWrapperState();
}

class NavigationWrapperState extends State<NavigationWrapper> {
  int selectedIndex = 0;

  // List of all main screens accessible via the Bottom Navigation Bar
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    CommunityScreen(), // The screen provided by the user
    ProjectsScreen(),
    PaymentsScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The current screen is displayed here
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      // The custom Bottom Navigation Bar is persistent across screens
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}