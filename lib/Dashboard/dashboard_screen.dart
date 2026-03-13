import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nileshapp/Community/community_screen.dart';
import 'package:nileshapp/Dashboard/orbitalnetworkcard.dart';
import 'package:nileshapp/Notification/notification_screen.dart';
import 'package:nileshapp/Projects/Suggestedprojectcard.dart';
import 'package:nileshapp/Projects/project_screen.dart';
import 'package:nileshapp/Team/team_screen.dart';
import 'package:nileshapp/Freelancers/freelancer_discovery_screen.dart';
import 'package:nileshapp/Chat/chat_list_screen.dart';
import 'package:nileshapp/Profile/profile_screen.dart';
import 'package:nileshapp/providers/auth_provider.dart';
import 'package:nileshapp/models/user_model.dart';
import 'package:nileshapp/main.dart';
import 'package:nileshapp/starting/forgot_screen.dart';
import 'package:nileshapp/starting/login_screen.dart';
import 'package:nileshapp/starting/register_screen.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB);
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
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

          // Main Scrollable Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildStatsRow(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Your Orbital Network'),
                  const SizedBox(height: 16),
                  _buildOrbitalNetworkList(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('AI Suggested Projects'),
                  const SizedBox(height: 16),
                  _buildSuggestedProjectsGrid(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Latest Notifications'),
                  const SizedBox(height: 16),
                  _buildNotificationItem(),
                  _buildNotificationItem(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildHeader() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.userModel;
        final userName = user?.name ?? 'User';
        final userInitials = userName.isNotEmpty 
            ? userName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join('').toUpperCase()
            : 'U';
        final userRole = user?.role == UserRole.freelancer ? 'Freelancer Dashboard' : 'Client Dashboard';
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Builder(
                  builder: (context) => GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer(); // 👈 Opens glass drawer
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: kPrimaryPurple,
                      backgroundImage: user?.profileImageUrl != null 
                          ? NetworkImage(user!.profileImageUrl!)
                          : null,
                      child: user?.profileImageUrl == null
                          ? Text(
                              userInitials,
                              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                // User Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, $userName ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      userRole,
                      style: TextStyle(
                        color: kTextSecondary.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationScreen()),
                );
              },
              child: const Icon(Icons.notifications, color: Colors.white, size: 30),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatCard(
          title: 'Total Earnings',
          value: '300k',
          icon: Icons.show_chart_rounded,
          iconColor: kAccentTeal,
          glowColor: kAccentTeal,
        ),
        StatCard(
          title: 'Active Projects',
          value: '18',
          icon: Icons.folder_open_rounded,
          iconColor: kPrimaryPurple,
          glowColor: kPrimaryPurple,
        ),
        StatCard(
          title: 'Endorsements',
          value: '90',
          icon: Icons.thumb_up_alt_rounded,
          iconColor: kAccentPink,
          glowColor: kAccentPink,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildOrbitalNetworkList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          OrbitalNetworkCard(
            title: 'Lorem ipsum obsenic etonited',
            color: kAccentTeal,
          ),
          OrbitalNetworkCard(
            title: 'Alcor Ne etlemed oir',
            color: kPrimaryPurple,
          ),
          OrbitalNetworkCard(
            title: 'Another Network Item',
            color: kAccentPink,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedProjectsGrid() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                SuggestedProjectCard(
                  title: 'AI- Synthesized Brand Identity Project',
                  description: 'AI Synthesized Brand Identity Project',
                  color: kAccentTeal,
                ),
                SuggestedProjectCard(
                  title: 'AI Synthesized Brand Identity Project',
                  description: 'AI Synthesized Brand Identity Project',
                  color: kPrimaryPurple,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                SuggestedProjectCard(
                  title: 'Alcor Ne clemed oruit lognad',
                  description: 'Alcor Ne clemed oruit lognad',
                  color: kAccentPink,
                ),
                SuggestedProjectCard(
                  title: 'AI Suggested Projects',
                  description: 'AI Suggested Projects',
                  color: kAccentTeal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active_rounded, color: kPrimaryPurple, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'New team invitation from Nexus Corp',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.more_vert, color: kTextSecondary.withOpacity(0.5)),
        ],
      ),
    );
  }
}


  // --- 🌌 FROSTED GLASS DRAWER ---
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          // Frosted Background
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  border: Border.all(
                    color: kPrimaryPurple.withOpacity(0.3),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryPurple.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Drawer Content
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  final user = authProvider.userModel;
                  final userName = user?.name ?? 'User';
                  
                  return DrawerHeader(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kPrimaryPurple, kCardColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white24,
                          backgroundImage: user?.profileImageUrl != null 
                              ? NetworkImage(user!.profileImageUrl!)
                              : null,
                          child: user?.profileImageUrl == null
                              ? Icon(Icons.person, color: Colors.white, size: 30)
                              : null,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hello, $userName 👋',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (user?.email != null) ...[
                                SizedBox(height: 4),
                                Text(
                                  user!.email,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              _drawerItem(context, Icons.forum_rounded, "Discussion Forum",destinationScreen: CommunityScreen()),
              _drawerItem(context, Icons.group_work, "Teams",destinationScreen: TeamsScreen()),
              _drawerItem(context, Icons.code_rounded, "Projects",destinationScreen: ProjectsScreen()),
              _drawerItem(context, Icons.people_rounded, "Discover Freelancers",destinationScreen: FreelancerDiscoveryScreen()),
              _drawerItem(context, Icons.chat_rounded, "Messages",destinationScreen: ChatListScreen()),
              const Divider(
                color: Colors.white24,
                thickness: 0.6,
                indent: 20,
                endIndent: 20,
              ),
              _drawerItem(context, Icons.person_rounded, "Profile",destinationScreen: ProfileScreen()),
              _drawerItem(context, Icons.settings_rounded, "Settings"),
             _drawerItem(
  context,
  Icons.logout_rounded,
  "Logout",
  color: kAccentPink,
  destinationScreen: LoginScreen(
    onSignUp: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegisterScreen(
            onLogin: () {
              Navigator.pop(context); // back to login
            },
          ),
        ),
      );
    },
    onForgotPassword: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ForgotPasswordScreen(
            onLogin: () {
              Navigator.pop(context); // back to login
            },
          ),
        ),
      );
    },
  ),
)


            ],
          ),
        ],
      ),
    );
  }

 Widget _drawerItem(BuildContext context, IconData icon, String title, {Color color = Colors.white, Widget? destinationScreen}) {
  return ListTile(
    leading: Icon(icon, color: color.withOpacity(0.9)),
    title: Text(
      title,
      style: TextStyle(
        color: color.withOpacity(0.9),
        fontWeight: FontWeight.w500,
      ),
    ),
    onTap: () {
      Navigator.pop(context); // Close the drawer first
      if (destinationScreen != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      }
    },
  );
}

