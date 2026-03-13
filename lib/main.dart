
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nileshapp/AI_TOOL/aitool_screen.dart';
import 'package:nileshapp/Community/community_screen.dart';
import 'package:nileshapp/Dashboard/dashboard_screen.dart';
import 'package:nileshapp/Notification/notification_screen.dart';
import 'package:nileshapp/Payment/payment_screen.dart';
import 'package:nileshapp/Profile/profile_screen.dart';
import 'package:nileshapp/Projects/project_screen.dart';
import 'package:nileshapp/ClientDashborad/PostProjectScreen.dart';
import 'package:nileshapp/starting/splash_screen.dart';
import 'package:nileshapp/services/firebase_service.dart';
import 'package:nileshapp/services/notification_service.dart';
import 'package:nileshapp/providers/auth_provider.dart';
import 'package:nileshapp/providers/user_provider.dart';
import 'package:nileshapp/providers/project_provider.dart';


const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB); 
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await FirebaseService.instance.initialize();
  
  // Initialize services
  await NotificationService.instance.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ],
      child: MaterialApp(
        title: 'TalentSphere',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: kDarkBackground,
          fontFamily: 'Inter',
          textTheme: const TextTheme(
            titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(color: kTextSecondary),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: kDarkBackground,
            elevation: 0,
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        routes: {
          '/post-project': (context) => const PostProjectScreen(),
        },
      ),
    );
  }
}

// Add this new StatefulWidget for navigation
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    ProjectsScreen(),
    CommunityScreen(),
    ProfileScreen(),
    AIToolsScreen(),
    NotificationScreen(),
    PaymentsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              color: kCardColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              selectedItemColor: kPrimaryPurple,
              unselectedItemColor: kTextSecondary,
              currentIndex: _selectedIndex,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Projects'),
                BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
                BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: 'AI Tools'),
                //BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
                //BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payments'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color glowColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 64) / 3,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(kCardRadius / 2),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: kGlowSpread,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: kTextSecondary.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
          const Text(
            'Name of doc titles',
            style: TextStyle(color: kTextSecondary, fontSize: 8),
          ),
        ],
      ),
    );
  }
}



