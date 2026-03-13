import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nileshapp/Freelancers/freelancer_discovery_screen.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({Key? key}) : super(key: key);

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  int selectedTab = 0; // 0 = Freelancers, 1 = Teams

  final List<Map<String, dynamic>> freelancers = [
    {"name": "Anya Sharma", "skills": "UI/UX, Figma", "price": "₹ 12,500", "rating": 4.5},
    {"name": "Rohan Patel", "skills": "React, Node.js", "price": "₹ 18,000", "rating": 4.7},
    {"name": "Sneha Verma", "skills": "Flutter, Firebase", "price": "₹ 15,000", "rating": 4.6},
  ];

  final List<Map<String, dynamic>> teams = [
    {"name": "Design Ninjas", "skills": "UI/UX, Branding", "price": "₹ 45,000", "rating": 4.8},
    {"name": "Code Titans", "skills": "Full Stack Dev", "price": "₹ 60,000", "rating": 4.9},
    {"name": "Data Squad", "skills": "AI, ML, Data", "price": "₹ 55,000", "rating": 4.7},
  ];

  @override
  Widget build(BuildContext context) {
    final list = selectedTab == 0 ? freelancers : teams;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Browse", style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // Tabs: Freelancers / Teams
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton("Freelancers", 0),
                const SizedBox(width: 10),
                _buildTabButton("Teams", 1),
              ],
            ),
            const SizedBox(height: 20),

            // Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // List - Navigate to freelancer discovery or show actual freelancers
            Expanded(
              child: selectedTab == 0
                  ? ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to freelancer discovery screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FreelancerDiscoveryScreen(),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1C1C3A), Color(0xFF12122B)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.purpleAccent.withOpacity(0.2),
                                child: const Icon(Icons.person, color: Colors.purpleAccent),
                              ),
                              title: Text(item["name"], style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                              subtitle: Text(item["skills"], style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purpleAccent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  // Navigate to freelancer discovery screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const FreelancerDiscoveryScreen(),
                                    ),
                                  );
                                },
                                child: const Text("View Profile"),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1C1C3A), Color(0xFF12122B)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.purpleAccent.withOpacity(0.2),
                              child: const Icon(Icons.person, color: Colors.purpleAccent),
                            ),
                            title: Text(item["name"], style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                            subtitle: Text(item["skills"], style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purpleAccent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Hire request sent to ${item["name"]}!"),
                                    backgroundColor: Colors.purpleAccent,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: const Text("Hire"),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purpleAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.purpleAccent),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
