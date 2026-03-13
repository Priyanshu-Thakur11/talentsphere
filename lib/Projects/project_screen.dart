import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nileshapp/Notification/segmentedpill_button.dart';
import 'package:nileshapp/Projects/projeacttab_button.dart';
import 'package:nileshapp/Projects/project_list_screen.dart';
import 'package:nileshapp/Team/task_card.dart';
import 'package:nileshapp/providers/auth_provider.dart';
import 'package:nileshapp/models/user_model.dart';

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

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show different content based on user role
        if (authProvider.userModel?.role == UserRole.admin) {
          return _buildAdminView();
        } else {
          return _buildUserView();
        }
      },
    );
  }

  Widget _buildAdminView() {
    return Scaffold(
      backgroundColor: kDarkBackground,
      body: Stack(
        children: [
          // Background
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
          
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildAdminTabs(),
                const SizedBox(height: 24),
                Expanded(
                  child: _getAdminTabContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserView() {
    return Scaffold(
      backgroundColor: kDarkBackground,
      body: Stack(
        children: [
          // Background
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
          
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildProjectTabs(),
                const SizedBox(height: 24),
                Expanded(
                  child: _getTabContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Header with Menu Button ---
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Projects',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.search_rounded, color: Colors.white, size: 30),
              const SizedBox(width: 16),
              // 👇 Updated menu icon with drawer open action
              // Builder(
              //   builder: (context) => GestureDetector(
              //     onTap: () {
              //       Scaffold.of(context).openDrawer();
              //     },
              //     child: const Icon(Icons.menu_rounded,
              //         color: Colors.white, size: 30),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Tabs for Projects ---
  Widget _buildProjectTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          ProjectTabButton(
            label: 'All Projects',
            isActive: selectedTabIndex == 0,
            onTap: () {
              setState(() => selectedTabIndex = 0);
            },
          ),
          ProjectTabButton(
            label: 'My Projects',
            isActive: selectedTabIndex == 1,
            onTap: () {
              setState(() => selectedTabIndex = 1);
            },
          ),
          ProjectTabButton(
            label: 'Available',
            isActive: selectedTabIndex == 2,
            onTap: () {
              setState(() => selectedTabIndex = 2);
            },
          ),
        ],
      ),
    );
  }

  // --- Admin Tabs ---
  Widget _buildAdminTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          ProjectTabButton(
            label: 'All Projects',
            isActive: selectedTabIndex == 0,
            onTap: () {
              setState(() => selectedTabIndex = 0);
            },
          ),
          ProjectTabButton(
            label: 'Published',
            isActive: selectedTabIndex == 1,
            onTap: () {
              setState(() => selectedTabIndex = 1);
            },
          ),
          ProjectTabButton(
            label: 'In Progress',
            isActive: selectedTabIndex == 2,
            onTap: () {
              setState(() => selectedTabIndex = 2);
            },
          ),
        ],
      ),
    );
  }

  // --- Tab Content ---
  Widget _getTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return const ProjectListScreen(listType: ProjectListType.all);
      case 1:
        return const ProjectListScreen(listType: ProjectListType.myProjects);
      case 2:
        return const ProjectListScreen(listType: ProjectListType.availableProjects);
      default:
        return const ProjectListScreen(listType: ProjectListType.all);
    }
  }

  // --- Admin Tab Content ---
  Widget _getAdminTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return const ProjectListScreen(listType: ProjectListType.all);
      case 1:
        return const ProjectListScreen(listType: ProjectListType.availableProjects);
      case 2:
        return const ProjectListScreen(listType: ProjectListType.all);
      default:
        return const ProjectListScreen(listType: ProjectListType.all);
    }
  }


//   // --- 🌌 Frosted Glass Drawer ---
//   Widget _buildDrawer() {
//     return Drawer(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       child: Stack(
//         children: [
//           // Frosted Glass Background
//           ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topRight: Radius.circular(30),
//               bottomRight: Radius.circular(30),
//             ),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.08),
//                   border: Border.all(
//                     color: kPrimaryPurple.withOpacity(0.3),
//                     width: 1.2,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: kPrimaryPurple.withOpacity(0.2),
//                       blurRadius: 12,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // Drawer Content
//           ListView(
//             padding: EdgeInsets.zero,
//             children: [
//               DrawerHeader(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [kPrimaryPurple, kCardColor],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: Row(
//                   children: const [
//                     CircleAvatar(
//                       radius: 28,
//                       backgroundColor: Colors.white24,
//                       child: Icon(Icons.person,
//                           color: Colors.white, size: 30),
//                     ),
//                     SizedBox(width: 16),
//                     Text(
//                       'Hello, Sahil 👋',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               _drawerItem(Icons.dashboard_rounded, "Dashboard"),
//               _drawerItem(Icons.folder_open_rounded, "Projects"),
//               _drawerItem(Icons.people_alt_rounded, "Team"),
//               _drawerItem(Icons.notifications_active_rounded, "Notifications"),
//               _drawerItem(Icons.settings_rounded, "Settings"),
//               const Divider(
//                   color: Colors.white24,
//                   thickness: 0.6,
//                   indent: 20,
//                   endIndent: 20),
//               _drawerItem(Icons.logout_rounded, "Logout", color: kAccentPink),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _drawerItem(IconData icon, String title,
//       {Color color = Colors.white}) {
//     return ListTile(
//       leading: Icon(icon, color: color.withOpacity(0.9)),
//       title: Text(
//         title,
//         style: TextStyle(
//           color: color.withOpacity(0.9),
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       onTap: () {
//         Navigator.pop(context); // Close drawer
//       },
//     );
//   }
} //}
