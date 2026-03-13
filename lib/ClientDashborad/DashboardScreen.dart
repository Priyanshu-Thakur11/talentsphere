import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nileshapp/ClientDashborad/PostProjectScreen.dart';
import 'package:nileshapp/ClientDashborad/browsescreen.dart';
import 'package:nileshapp/ClientDashborad/chatscreen.dart';
import 'package:nileshapp/ClientDashborad/profile.dart';
import 'package:nileshapp/providers/project_provider.dart';
import 'package:nileshapp/providers/auth_provider.dart';
import 'package:nileshapp/models/project_model.dart';
import 'package:nileshapp/Notification/notification_screen.dart';
import 'package:nileshapp/starting/splash_screen.dart';
import 'dart:async';
import 'dart:ui';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB);
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;

class ClientDashboardScreen extends StatefulWidget {
  const ClientDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ClientDashboardScreen> createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends State<ClientDashboardScreen> {
  int _selectedIndex = 0;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadProjects() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    
    if (authProvider.userModel != null) {
      await projectProvider.loadMyProjects(authProvider.userModel!.id);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // Reload projects when switching to projects tab
    if (index == 1) {
      _loadProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      drawer: _buildDrawer(),
      body: _getSelectedScreen(),
      floatingActionButton: _selectedIndex == 1 ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostProjectScreen()),
          );
        },
        backgroundColor: Colors.purpleAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ) : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF121220),
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.white54,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.business_center), label: "Projects"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Browse"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
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
              _drawerItem(context, Icons.home, "Home"),
              _drawerItem(context, Icons.business_center, "Projects"),
              _drawerItem(context, Icons.search, "Browse"),
                        _drawerItem(context, Icons.chat_bubble_outline, "Messages"),
              _drawerItem(context, Icons.person_outline, "Profile"),
              const Divider(
                color: Colors.white24,
                thickness: 0.6,
                indent: 20,
                endIndent: 20,
              ),
              _drawerItem(context, Icons.settings, "Settings"),
              _drawerItem(
                context,
                Icons.logout,
                "Logout",
                color: kAccentPink,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, {Color color = Colors.white}) {
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
        if (title == "Home") {
          setState(() => _selectedIndex = 0);
        } else if (title == "Projects") {
          setState(() => _selectedIndex = 1);
        } else if (title == "Browse") {
          setState(() => _selectedIndex = 2);
        } else if (title == "Messages") {
          setState(() => _selectedIndex = 3);
        } else if (title == "Profile") {
          setState(() => _selectedIndex = 4);
        } else if (title == "Settings") {
          _showSettingsDialog();
        } else if (title == "Logout") {
          _handleLogout();
        }
      },
    );
  }

  void _handleLogout() async {
    await Provider.of<AuthProvider>(context, listen: false).signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SplashScreen()),
        (route) => false,
      );
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('Settings', style: GoogleFonts.poppins(color: Colors.white)),
        content: Text('...........!', style: GoogleFonts.poppins(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.purpleAccent)),
          ),
        ],
      ),
    );
  }

  // Tab selection
  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeSection();
      case 1:
        return _buildProjectsSection();
      case 2:
        return const BrowseScreen();
      case 3:
        return const ChatScreen();
      case 4:
        return const ClientProfileScreen();
      default:
        return _buildHomeSection();
    }
  }

  // Home tab with freelancer-style AppBar
  Widget _buildHomeSection() {
    return Stack(
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
                _buildAutoScrollingMetrics(),
                const SizedBox(height: 30),
                Text(
                  "Financial Overview",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 105, 105, 105),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      "📊 Monthly Spending Graph",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PostProjectScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFFB37EFF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              "+ Post New Project",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("View Teams clicked")),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              "View Teams",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  "Your Team",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                _buildTeamTile("Team Member 1", "New proposal for Website Redesign"),
                const SizedBox(height: 10),
                _buildTeamTile("Team Member 2", "New proposal for App Redesign"),
                const SizedBox(height: 20),
                Text(
                  "Latest Activity",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                _buildActivityTile("Team Member 1", "Milestone approved for Mobile App"),
                const SizedBox(height: 10),
                _buildActivityTile("Team Member 2", "Milestone approved for Website"),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.userModel;
        final userName = user?.name ?? 'User';
        final userInitials = userName.isNotEmpty 
            ? userName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join('').toUpperCase()
            : 'U';
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $userName 👋',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Client Dashboard',
                          style: TextStyle(
                            color: kTextSecondary.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

  // Projects tab
  Widget _buildProjectsSection() {
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, child) {
        if (projectProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.purpleAccent,
            ),
          );
        }

        if (projectProvider.myProjects.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open,
                  color: Colors.white54,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  "No projects found. Post a new project!",
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PostProjectScreen()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Post Project'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadProjects,
          color: Colors.purpleAccent,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: projectProvider.myProjects.length,
            itemBuilder: (context, index) {
              final project = projectProvider.myProjects[index];
              return _buildProjectCard(project);
            },
          ),
        );
      },
    );
  }
  
  Widget _buildProjectCard(ProjectModel project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.pinkAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  project.title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildStatusChip(project.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            project.description,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.attach_money, color: Colors.cyanAccent, size: 16),
              const SizedBox(width: 4),
              Text(
                "₹${project.budget.toStringAsFixed(0)}",
                style: GoogleFonts.poppins(
                  color: Colors.cyanAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.schedule, color: Colors.pinkAccent, size: 16),
              const SizedBox(width: 4),
              Text(
                "${project.duration} days",
                style: GoogleFonts.poppins(
                  color: Colors.pinkAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (project.requiredSkills.isNotEmpty) ...[
            Text(
              "Skills: ${project.requiredSkills.join(', ')}",
              style: GoogleFonts.poppins(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            "Proposals: ${project.proposalsCount}",
            style: GoogleFonts.poppins(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to project details
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Project details coming soon!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('View Details'),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {
                  // TODO: Navigate to edit project
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit project coming soon!')),
                  );
                },
                icon: const Icon(Icons.edit, color: Colors.cyanAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ProjectStatus status) {
    Color color;
    String label;
    
    switch (status) {
      case ProjectStatus.published:
        color = Colors.green;
        label = 'Published';
        break;
      case ProjectStatus.inProgress:
        color = Colors.orange;
        label = 'In Progress';
        break;
      case ProjectStatus.completed:
        color = Colors.blue;
        label = 'Completed';
        break;
      case ProjectStatus.draft:
        color = Colors.grey;
        label = 'Draft';
        break;
      case ProjectStatus.cancelled:
        color = Colors.red;
        label = 'Cancelled';
        break;
      case ProjectStatus.disputed:
        color = Colors.red;
        label = 'Disputed';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Reusable components
  Widget _buildMetricCard(IconData icon, String title, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A145A), Color(0xFF45108A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoScrollingMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Key Metrics",
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 121,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemCount: 100, // Create a long list for looping effect
            itemBuilder: (context, index) {
              final metrics = [
                _buildMetricCard(Icons.work_outline, "Active Projects", "5"),
                _buildMetricCard(Icons.attach_money, "Total Spent", "150k"),
                _buildMetricCard(Icons.star_border, "Pending Reviews", "2"),
                _buildMetricCard(Icons.person, "New Freelancers", "12"),
                _buildMetricCard(Icons.trending_up, "Growth", "+15%"),
                _buildMetricCard(Icons.check_circle, "Completed", "8"),
              ];
              final metricIndex = index % metrics.length;
              return Padding(
                padding: EdgeInsets.only(
                  right: index < 99 ? 18 : 18,
                  left: index == 0 ? 0 : 0,
                ),
                child: metrics[metricIndex],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTeamTile(String name, String task) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF181828),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.purpleAccent,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w500)),
                Text(task,
                    style: GoogleFonts.poppins(
                        color: Colors.white54, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(String name, String update) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF181828),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w500)),
                Text(update,
                    style: GoogleFonts.poppins(
                        color: Colors.white54, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
