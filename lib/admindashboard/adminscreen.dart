import 'package:flutter/material.dart';
import 'package:nileshapp/starting/login_screen.dart';

// -------------------- THEME CONSTANTS --------------------
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB);
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);
const double kCardRadius = 20.0;

// -------------------- MAIN APP --------------------
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kDarkBackground,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: kTextSecondary),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      home: const MainDashboard(),
    );
  }
}

// -------------------- MAIN DASHBOARD WITH NAVIGATION --------------------
class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    ManageTeamsScreen(),
    AdminDashboardScreen(),
    ManagePaymentsScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kCardColor,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: kAccentTeal,
        unselectedItemColor: kTextSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.groups_2), label: "Teams"),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.payments), label: "Payments"),
        ],
      ),
    );
  }
}

// ===================================================================
// ======================== MANAGE TEAMS SCREEN =======================
// ===================================================================

class ManageTeamsScreen extends StatefulWidget {
  const ManageTeamsScreen({super.key});

  @override
  State<ManageTeamsScreen> createState() => _ManageTeamsScreenState();
}

class _ManageTeamsScreenState extends State<ManageTeamsScreen> {
  bool isTableView = false;
  bool isTeamsListActive = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Manage Teams",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 24),

            // Toggle Buttons
            Row(
              children: [
                _TabButton(
                  label: "Teams List",
                  isActive: isTeamsListActive,
                  onTap: () => setState(() => isTeamsListActive = true),
                ),
                const SizedBox(width: 10),
                _TabButton(
                  label: "Pending Approvals",
                  isActive: !isTeamsListActive,
                  onTap: () => setState(() => isTeamsListActive = false),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Search Bar + Table Toggle
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: kCardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kPrimaryPurple.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search_rounded, color: kTextSecondary),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: TextStyle(color: kTextSecondary),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Icon(Icons.mic_none_rounded, color: kTextSecondary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    const Text("Table View", style: TextStyle(color: kTextSecondary)),
                    const SizedBox(width: 8),
                    Switch(
                      value: isTableView,
                      activeColor: kAccentTeal,
                      onChanged: (val) => setState(() => isTableView = val),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Team Cards
            const _TeamCard(
              logo: Icons.cloud_rounded,
              logoColor: kAccentTeal,
              teamName: "Cosmic Labs",
              leader: "Jane Doe",
              projects: "5 Projects",
              members: "5 Members",
              statusColor: Colors.cyanAccent,
            ),
            const _TeamCard(
              logo: Icons.waves_rounded,
              logoColor: kPrimaryPurple,
              teamName: "Nexus Corp",
              leader: "Rajesh",
              projects: "4 Projects",
              members: "6 Members",
              statusColor: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}

// TEAM CARD WIDGET
class _TeamCard extends StatelessWidget {
  final IconData logo;
  final Color logoColor;
  final String teamName;
  final String leader;
  final String projects;
  final String members;
  final Color statusColor;

  const _TeamCard({
    required this.logo,
    required this.logoColor,
    required this.teamName,
    required this.leader,
    required this.projects,
    required this.members,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: kPrimaryPurple.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: logoColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(logo, color: logoColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(teamName, style: const TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 4),
                Text("Leader: $leader",
                    style: const TextStyle(color: kTextSecondary, fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(projects, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(width: 12),
                    Text(members, style: const TextStyle(color: kAccentTeal, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor.withOpacity(0.15),
            ),
            child: Icon(Icons.more_horiz, size: 18, color: statusColor),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// ======================== ADMIN DASHBOARD ==========================
// ===================================================================

 // ✅ make sure this path matches your project structure

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      {'name': 'User 1', 'email': 'user1@email.com', 'role': 'Designer', 'status': 'Active'},
      {'name': 'User 2', 'email': 'user2@email.com', 'role': 'Flutter Dev', 'status': 'Pending'},
      {'name': 'User 3', 'email': 'user3@email.com', 'role': 'Manager', 'status': 'Inactive'},
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header Row (Title + Logout Button)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Admin Dashboard",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentTeal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // ✅ Logout → Go back to Login Screen
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(
                          onSignUp: () {},
                          onForgotPassword: () {},
                        ),
                      ),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text("Logout"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔹 User List Section
            Container(
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kPrimaryPurple.withOpacity(0.4)),
              ),
              child: Column(
                children: users
                    .map(
                      (user) => ListTile(
                        leading: const Icon(Icons.person, color: kAccentTeal),
                        title: Text(user['name']!, style: const TextStyle(color: Colors.white)),
                        subtitle: Text(
                          user['email']!,
                          style: const TextStyle(color: kTextSecondary),
                        ),
                        trailing: Text(
                          user['status']!,
                          style: TextStyle(
                            color: user['status'] == 'Active'
                                ? kAccentTeal
                                : user['status'] == 'Pending'
                                    ? Colors.amber
                                    : Colors.redAccent,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ===================================================================
// ======================== MANAGE PAYMENTS ==========================
// ===================================================================

class ManagePaymentsScreen extends StatelessWidget {
  const ManagePaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Manage Payments",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _InfoCard(title: "Total Earnings", value: "\$1.2M", color: kPrimaryPurple),
                _InfoCard(title: "Pending", value: "\$50K", color: kAccentTeal),
                _InfoCard(title: "Disputes", value: "12", color: kAccentPink),
              ],
            ),

            const SizedBox(height: 30),

            const _PaymentRow("TXN-001", "\$2750", "Oct 20", "Completed", Colors.teal),
            const _PaymentRow("TXN-002", "\$1800", "Oct 21", "Pending", Colors.amber),
            const _PaymentRow("TXN-003", "\$950", "Oct 23", "Disputed", Colors.redAccent),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title, value;
  final Color color;

  const _InfoCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(kCardRadius),
          border: Border.all(color: color.withOpacity(0.6)),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(value,
                style:
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final String id, amount, date, status;
  final Color color;

  const _PaymentRow(this.id, this.amount, this.date, this.status, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(id, style: const TextStyle(color: Colors.white)),
          Text(amount, style: const TextStyle(color: Colors.white)),
          Text(date, style: const TextStyle(color: Colors.white70)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// ======================== REUSABLE WIDGET ==========================
// ===================================================================

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _TabButton({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [kPrimaryPurple, kAccentTeal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: isActive ? Colors.transparent : kTextSecondary.withOpacity(0.4),
            ),
          ),
          child: Center(
            child: Text(label,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}
