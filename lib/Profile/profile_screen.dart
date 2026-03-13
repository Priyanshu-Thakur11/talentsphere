
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nileshapp/Profile/circutboard.dart';
import 'package:nileshapp/Profile/custon_tag.dart';
import 'package:nileshapp/Profile/profiletab_button.dart';
import 'package:nileshapp/Profile/edit_profile_screen.dart';
import 'package:nileshapp/providers/auth_provider.dart';
import 'package:nileshapp/models/user_model.dart';
import 'package:nileshapp/Reviews/reviews_list_screen.dart';
import 'package:nileshapp/models/project_model.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB);
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int activeTabIndex = 0; // 0 = About, 1 = Portfolio, 2 = Endorsements

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
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

          // Scrollable Body
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                _buildProfileBody(),
              ],
            ),
          ),

          // Floating Edit Button
          Positioned(
            bottom: 30,
            right: 30,
            child: _buildFloatingActionButton(),
          ),
        ],
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 380,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Circuit Background
          const CircuitBoardBackground(),

          // Profile Avatar
          Positioned(
            top: 100,
            child: Container(
              width: 150,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kAccentTeal.withOpacity(0.8), width: 3),
                boxShadow: [
                  BoxShadow(color: kAccentTeal.withOpacity(0.6), blurRadius: 15, spreadRadius: 2),
                ],
                image: const DecorationImage(
                  image: NetworkImage('https://wallpapers.com/images/hd/best-profile-pictures-7c4fnz0x5hts559b.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Tabs
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => activeTabIndex = 0),
                    child: ProfileTabButton(label: 'About', isActive: activeTabIndex == 0),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => activeTabIndex = 1),
                    child: ProfileTabButton(label: 'Portfolio', isActive: activeTabIndex == 1),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => activeTabIndex = 2),
                    child: ProfileTabButton(label: 'Endorsements', isActive: activeTabIndex == 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileBody() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.userModel;
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                user?.name ?? 'User Name',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (user?.bio != null && user!.bio!.isNotEmpty) ...[
                Text(
                  user.bio!,
                  style: TextStyle(
                    color: kTextSecondary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (user?.location != null && user!.location!.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(Icons.location_on, color: kTextSecondary, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      user.location!,
                      style: TextStyle(
                        color: kTextSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ] else ...[
                const SizedBox(height: 20),
              ],

          // Status Pills
          Row(
            children: [
              _buildStatusPill(Icons.group, 'Open to Team', kAccentTeal),
              const SizedBox(width: 16),
              _buildStatusPill(Icons.circle, 'Working on Project', kTextSecondary.withOpacity(0.6)),
            ],
          ),
          const SizedBox(height: 30),

          // Tabs Content
          if (activeTabIndex == 0) _buildAboutTab(),
          if (activeTabIndex == 1) _buildPortfolioTab(),
          if (activeTabIndex == 2) _buildEndorsementsTab(),

          const SizedBox(height: 100), // Space for floating button
        ],
      ),
    );
      },
    );
  }

  Widget _buildAboutTab() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.userModel;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Professional Information
            _buildSectionCard(
              title: 'Professional Information',
              icon: Icons.work,
              children: [
                if (user?.role != null) ...[
                  _buildInfoRow('Role', _getRoleDisplayName(user!.role)),
                  const SizedBox(height: 8),
                ],
                if (user?.hourlyRate != null) ...[
                  _buildInfoRow('Hourly Rate', '₹${user!.hourlyRate!.toStringAsFixed(0)}/hour'),
                  const SizedBox(height: 8),
                ],
                if (user?.totalEarnings != null) ...[
                  _buildInfoRow('Total Earnings', '₹${user!.totalEarnings}'),
                  const SizedBox(height: 8),
                ],
                if (user?.completedProjects != null) ...[
                  _buildInfoRow('Completed Projects', '${user!.completedProjects}'),
                  const SizedBox(height: 8),
                ],
                if (user?.rating != null && user!.rating > 0) ...[
                  _buildRatingRow('Rating', user.rating, user.totalReviews),
                  const SizedBox(height: 8),
                ],
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Skills Section
            _buildSectionCard(
              title: 'Skills & Expertise',
              icon: Icons.star,
              children: [
                if (user?.skills != null && user!.skills.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: user.skills.map((skill) {
                      return CustomTag(
                        icon: Icons.star,
                        label: skill,
                        backgroundColor: kAccentTeal.withOpacity(0.2),
                        textColor: kAccentTeal,
                      );
                    }).toList(),
                  ),
                ] else ...[
                  Text(
                    'No skills added yet',
                    style: TextStyle(
                      color: kTextSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Certifications
            if (user?.certifications != null && user!.certifications.isNotEmpty) ...[
              _buildSectionCard(
                title: 'Certifications',
                icon: Icons.verified,
                children: [
                  ...user.certifications.map((cert) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: kAccentTeal, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cert,
                            style: TextStyle(color: kTextSecondary, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 20),
            ],
            
            // Contact Information
            _buildSectionCard(
              title: 'Contact Information',
              icon: Icons.contact_mail,
              children: [
                if (user?.email != null) ...[
                  _buildContactInfo(Icons.email, user!.email),
                  const SizedBox(height: 8),
                ],
                if (user?.phoneNumber != null && user!.phoneNumber!.isNotEmpty) ...[
                  _buildContactInfo(Icons.phone, user.phoneNumber!),
                  const SizedBox(height: 8),
                ],
                if (user?.location != null && user!.location!.isNotEmpty) ...[
                  _buildContactInfo(Icons.location_on, user.location!),
                  const SizedBox(height: 8),
                ],
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Bio Section
            if (user?.bio != null && user!.bio!.isNotEmpty) ...[
              _buildSectionCard(
                title: 'About Me',
                icon: Icons.person,
                children: [
                  Text(
                    user.bio!,
                    style: TextStyle(
                      color: kTextSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: kTextSecondary, size: 16),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: kTextSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildPortfolioTab() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.userModel;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resume Section
            if (user?.resumeUrl != null && user!.resumeUrl!.isNotEmpty) ...[
              _buildSectionCard(
                title: 'Resume',
                icon: Icons.description,
                children: [
                  Row(
                    children: [
                      Icon(Icons.file_download, color: kAccentTeal, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Download Resume',
                          style: TextStyle(color: kTextSecondary, fontSize: 14),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement resume download
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kAccentTeal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Download', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
            
            // Portfolio Projects
            _buildSectionCard(
              title: 'Portfolio Projects',
              icon: Icons.work_outline,
              children: [
                // TODO: Load user's completed projects
                Text(
                  'No portfolio projects yet',
                  style: TextStyle(color: kTextSecondary, fontSize: 14),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to add portfolio project
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Add Project', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Skills Showcase
            if (user?.skills != null && user!.skills.isNotEmpty) ...[
              _buildSectionCard(
                title: 'Skills Showcase',
                icon: Icons.star_outline,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: user.skills.map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [kAccentTeal.withOpacity(0.2), kPrimaryPurple.withOpacity(0.2)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: kAccentTeal.withOpacity(0.3)),
                        ),
                        child: Text(
                          skill,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildEndorsementsTab() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.userModel;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Rating
            if (user?.rating != null && user!.rating > 0) ...[
              _buildSectionCard(
                title: 'Overall Rating',
                icon: Icons.star,
                children: [
                  Row(
                    children: [
                      // Star rating display
                      ...List.generate(5, (index) {
                        return Icon(
                          index < user!.rating.floor() 
                            ? Icons.star 
                            : index < user.rating 
                              ? Icons.star_half 
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 24,
                        );
                      }),
                      const SizedBox(width: 12),
                      Text(
                        '${user.rating.toStringAsFixed(1)} (${user.totalReviews} reviews)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
            
            // Reviews Section
            _buildSectionCard(
              title: 'Client Reviews',
              icon: Icons.rate_review,
              children: [
                // TODO: Load actual reviews
                _buildReviewItem(
                  clientName: 'John Doe',
                  rating: 5.0,
                  review: 'Excellent work! Delivered on time and exceeded expectations.',
                  projectTitle: 'Mobile App Development',
                  date: '2 weeks ago',
                ),
                const SizedBox(height: 16),
                _buildReviewItem(
                  clientName: 'Jane Smith',
                  rating: 4.5,
                  review: 'Great communication and quality work. Highly recommended!',
                  projectTitle: 'Web Design Project',
                  date: '1 month ago',
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewsListScreen(
                            userId: user.id,
                            targetRole: user.role == UserRole.freelancer 
                              ? ReviewTarget.freelancer 
                              : ReviewTarget.client,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('View All Reviews', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Testimonials
            _buildSectionCard(
              title: 'Testimonials',
              icon: Icons.format_quote,
              children: [
                _buildTestimonialItem(
                  text: 'Working with this freelancer was a great experience. Professional, reliable, and skilled.',
                  author: 'Tech Startup CEO',
                  company: 'InnovateCorp',
                ),
                const SizedBox(height: 16),
                _buildTestimonialItem(
                  text: 'Outstanding work quality and attention to detail. Will definitely work together again.',
                  author: 'Project Manager',
                  company: 'DesignStudio',
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusPill(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EditProfileScreen(),
          ),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [kAccentTeal, kAccentPink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: kAccentTeal.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.edit, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  // Helper Methods
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPrimaryPurple.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: kPrimaryPurple.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: kAccentTeal, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: kTextSecondary,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingRow(String label, double rating, int totalReviews) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: kTextSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 12),
        ...List.generate(5, (index) {
          return Icon(
            index < rating.floor() 
              ? Icons.star 
              : index < rating 
                ? Icons.star_half 
                : Icons.star_border,
            color: Colors.amber,
            size: 16,
          );
        }),
        const SizedBox(width: 8),
        Text(
          '${rating.toStringAsFixed(1)} (${totalReviews})',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewItem({
    required String clientName,
    required double rating,
    required String review,
    required String projectTitle,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kPrimaryPurple.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: kAccentTeal,
                child: Text(
                  clientName[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clientName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      projectTitle,
                      style: TextStyle(
                        color: kTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating.floor() 
                      ? Icons.star 
                      : index < rating 
                        ? Icons.star_half 
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 14,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review,
            style: TextStyle(
              color: kTextSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              color: kTextSecondary.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialItem({
    required String text,
    required String author,
    required String company,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kAccentTeal.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote,
            color: kAccentTeal,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              color: kTextSecondary,
              fontSize: 13,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    author,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    company,
                    style: TextStyle(
                      color: kTextSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.freelancer:
        return 'Freelancer';
      case UserRole.client:
        return 'Client';
      case UserRole.admin:
        return 'Admin';
    }
  }
}
