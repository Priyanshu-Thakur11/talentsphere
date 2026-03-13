import 'package:flutter/material.dart';
import 'package:nileshapp/services/firestore_service.dart';
import 'package:nileshapp/models/user_model.dart';
import 'package:nileshapp/Profile/profile_screen.dart';
import 'package:nileshapp/Chat/chat_screen.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB);
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;

class FreelancerDiscoveryScreen extends StatefulWidget {
  const FreelancerDiscoveryScreen({super.key});

  @override
  State<FreelancerDiscoveryScreen> createState() => _FreelancerDiscoveryScreenState();
}

class _FreelancerDiscoveryScreenState extends State<FreelancerDiscoveryScreen> {
  List<UserModel> _freelancers = [];
  List<UserModel> _filteredFreelancers = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  List<String> _selectedSkills = [];
  double _minRating = 0.0;
  double _maxHourlyRate = 1000.0;

  @override
  void initState() {
    super.initState();
    _loadFreelancers();
  }

  Future<void> _loadFreelancers() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      _freelancers = await FirestoreService.instance.getUsers(
        role: UserRole.freelancer,
        limit: 50,
      );

      _filteredFreelancers = _freelancers;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  void _filterFreelancers() {
    setState(() {
      _filteredFreelancers = _freelancers.where((freelancer) {
        // Search filter
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          if (!freelancer.name.toLowerCase().contains(query) &&
              (freelancer.bio?.toLowerCase().contains(query) != true) &&
              !freelancer.skills.any((skill) => skill.toLowerCase().contains(query))) {
            return false;
          }
        }

        // Skills filter
        if (_selectedSkills.isNotEmpty) {
          if (!_selectedSkills.any((skill) => freelancer.skills.contains(skill))) {
            return false;
          }
        }

        // Rating filter
        if (freelancer.rating < _minRating) {
          return false;
        }

        // Hourly rate filter
        if (freelancer.hourlyRate != null && freelancer.hourlyRate! > _maxHourlyRate) {
          return false;
        }

        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: AppBar(
        backgroundColor: kDarkBackground,
        elevation: 0,
        title: const Text(
          'Discover Freelancers',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
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
                _buildSearchBar(),
                _buildFilterChips(),
                Expanded(
                  child: _buildBody(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kPrimaryPurple.withOpacity(0.3)),
        ),
        child: TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
            _filterFreelancers();
          },
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search freelancers by name, skills, or bio...',
            hintStyle: TextStyle(color: kTextSecondary),
            prefixIcon: Icon(Icons.search, color: kTextSecondary),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    if (_selectedSkills.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _selectedSkills.map((skill) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
                label: Text(skill),
                backgroundColor: kAccentTeal.withOpacity(0.2),
                labelStyle: const TextStyle(color: kAccentTeal),
                deleteIcon: const Icon(Icons.close, color: kAccentTeal, size: 16),
                onDeleted: () {
                  setState(() {
                    _selectedSkills.remove(skill);
                  });
                  _filterFreelancers();
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: kPrimaryPurple,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Error: $_error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFreelancers,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredFreelancers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search,
              color: kTextSecondary,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'No freelancers found',
              style: TextStyle(
                color: kTextSecondary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search criteria',
              style: TextStyle(
                color: kTextSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFreelancers,
      color: kPrimaryPurple,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredFreelancers.length,
        itemBuilder: (context, index) {
          return _buildFreelancerCard(_filteredFreelancers[index]);
        },
      ),
    );
  }

  Widget _buildFreelancerCard(UserModel freelancer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: kPrimaryPurple.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: kPrimaryPurple.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: kAccentTeal,
                backgroundImage: freelancer.profileImageUrl != null
                    ? NetworkImage(freelancer.profileImageUrl!)
                    : null,
                child: freelancer.profileImageUrl == null
                    ? Text(
                        freelancer.name.isNotEmpty ? freelancer.name[0].toUpperCase() : 'F',
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      freelancer.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (freelancer.bio != null && freelancer.bio!.isNotEmpty) ...[
                      Text(
                        freelancer.bio!,
                        style: TextStyle(
                          color: kTextSecondary,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                    ],
                    Row(
                      children: [
                        if (freelancer.hourlyRate != null) ...[
                          Icon(Icons.attach_money, color: kAccentTeal, size: 16),
                          Text(
                            '₹${freelancer.hourlyRate!.toStringAsFixed(0)}/hr',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        if (freelancer.rating > 0) ...[
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(
                            '${freelancer.rating.toStringAsFixed(1)} (${freelancer.totalReviews})',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Skills
          if (freelancer.skills.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: freelancer.skills.take(5).map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: kAccentTeal.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    skill,
                    style: const TextStyle(
                      color: kAccentTeal,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          
          // Stats
          Row(
            children: [
              _buildStatItem(
                Icons.work,
                '${freelancer.completedProjects} Projects',
                kAccentTeal,
              ),
              const SizedBox(width: 16),
              _buildStatItem(
                Icons.location_on,
                freelancer.location ?? 'Remote',
                kTextSecondary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _viewProfile(freelancer),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'View Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _startChat(freelancer),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentTeal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Start Chat',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _viewProfile(UserModel freelancer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(),
      ),
    );
  }

  void _startChat(UserModel freelancer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          otherUserId: freelancer.id,
          otherUserName: freelancer.name,
          otherUserImageUrl: freelancer.profileImageUrl,
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kCardColor,
        title: const Text(
          'Filter Freelancers',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Skills filter
            const Text(
              'Skills',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Flutter', 'React', 'Node.js', 'Python', 'UI/UX', 'Mobile Development'].map((skill) {
                final isSelected = _selectedSkills.contains(skill);
                return FilterChip(
                  label: Text(skill),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedSkills.add(skill);
                      } else {
                        _selectedSkills.remove(skill);
                      }
                    });
                  },
                  backgroundColor: kCardColor,
                  selectedColor: kAccentTeal.withOpacity(0.3),
                  labelStyle: TextStyle(
                    color: isSelected ? kAccentTeal : Colors.white,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            
            // Rating filter
            const Text(
              'Minimum Rating',
              style: TextStyle(color: Colors.white),
            ),
            Slider(
              value: _minRating,
              min: 0.0,
              max: 5.0,
              divisions: 10,
              activeColor: kAccentTeal,
              inactiveColor: kTextSecondary,
              onChanged: (value) {
                setState(() {
                  _minRating = value;
                });
              },
            ),
            Text(
              '${_minRating.toStringAsFixed(1)} stars',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            
            // Hourly rate filter
            const Text(
              'Maximum Hourly Rate',
              style: TextStyle(color: Colors.white),
            ),
            Slider(
              value: _maxHourlyRate,
              min: 10.0,
              max: 1000.0,
              divisions: 99,
              activeColor: kAccentTeal,
              inactiveColor: kTextSecondary,
              onChanged: (value) {
                setState(() {
                  _maxHourlyRate = value;
                });
              },
            ),
            Text(
              '₹${_maxHourlyRate.toStringAsFixed(0)}/hour',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedSkills.clear();
                _minRating = 0.0;
                _maxHourlyRate = 1000.0;
              });
              _filterFreelancers();
              Navigator.pop(context);
            },
            child: const Text('Clear All'),
          ),
          ElevatedButton(
            onPressed: () {
              _filterFreelancers();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryPurple,
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
