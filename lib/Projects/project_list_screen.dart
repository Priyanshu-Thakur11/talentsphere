import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nileshapp/providers/project_provider.dart';
import 'package:nileshapp/providers/auth_provider.dart';
import 'package:nileshapp/models/project_model.dart';
import 'package:nileshapp/models/user_model.dart';
import 'package:nileshapp/Projects/edit_project_screen.dart';
import 'package:nileshapp/Projects/project_details_screen.dart';
import 'package:nileshapp/Reviews/review_screen.dart';
import 'package:nileshapp/Reviews/reviews_list_screen.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB);
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;

class ProjectListScreen extends StatefulWidget {
  final ProjectListType listType;
  
  const ProjectListScreen({
    super.key,
    this.listType = ProjectListType.all,
  });

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

enum ProjectListType { all, myProjects, availableProjects }

class _ProjectListScreenState extends State<ProjectListScreen> {
  String _searchQuery = '';
  ProjectStatus? _selectedStatus;
  
  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.userModel == null) return;

    switch (widget.listType) {
      case ProjectListType.myProjects:
        // Load projects where user is either client or freelancer
        await projectProvider.loadMyProjects(authProvider.userModel!.id);
        break;
      case ProjectListType.availableProjects:
        // Load all published projects for freelancers to browse
        await projectProvider.loadAvailableProjects();
        break;
      case ProjectListType.all:
        // Load all projects regardless of user role - visible to everyone
        await projectProvider.loadAllProjects();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                _buildSearchAndFilters(),
                Expanded(
                  child: Consumer<ProjectProvider>(
                    builder: (context, projectProvider, child) {
                      if (projectProvider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryPurple,
                          ),
                        );
                      }

                      if (projectProvider.error != null) {
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
                                'Error: ${projectProvider.error}',
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadProjects,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      final projects = _getFilteredProjects(projectProvider);
                      
                      if (projects.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder_open,
                                color: kTextSecondary,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No projects found',
                                style: TextStyle(
                                  color: kTextSecondary,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: _loadProjects,
                        color: kPrimaryPurple,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            return _buildProjectCard(projects[index]);
                          },
                        ),
                      );
                    },
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
    String title = 'All Projects';
    switch (widget.listType) {
      case ProjectListType.myProjects:
        title = 'My Projects';
        break;
      case ProjectListType.availableProjects:
        title = 'Available Projects';
        break;
      case ProjectListType.all:
        title = 'All Projects';
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.userModel?.role == UserRole.client) {
                return IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/post-project');
                  },
                  icon: const Icon(
                    Icons.add,
                    color: kPrimaryPurple,
                    size: 30,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Search bar
          Container(
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
              },
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search projects...',
                hintStyle: TextStyle(color: kTextSecondary),
                prefixIcon: Icon(Icons.search, color: kTextSecondary),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', _selectedStatus == null, () {
                  setState(() {
                    _selectedStatus = null;
                  });
                }),
                _buildFilterChip('Published', _selectedStatus == ProjectStatus.published, () {
                  setState(() {
                    _selectedStatus = ProjectStatus.published;
                  });
                }),
                _buildFilterChip('In Progress', _selectedStatus == ProjectStatus.inProgress, () {
                  setState(() {
                    _selectedStatus = ProjectStatus.inProgress;
                  });
                }),
                _buildFilterChip('Completed', _selectedStatus == ProjectStatus.completed, () {
                  setState(() {
                    _selectedStatus = ProjectStatus.completed;
                  });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? kPrimaryPurple : kCardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? kPrimaryPurple : kTextSecondary.withOpacity(0.3),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : kTextSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(ProjectModel project) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  project.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildStatusChip(project.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            project.description,
            style: TextStyle(
              color: kTextSecondary,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          
          // Skills
          if (project.requiredSkills.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: project.requiredSkills.take(3).map((skill) {
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
            const SizedBox(height: 12),
          ],
          
          // Project details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.attach_money, color: kAccentTeal, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '₹${project.budget.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.schedule, color: kTextSecondary, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${project.duration} days',
                    style: TextStyle(color: kTextSecondary),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.people, color: kTextSecondary, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${project.proposalsCount} proposals',
                    style: TextStyle(color: kTextSecondary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _viewProjectDetails(project),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.userModel?.role == UserRole.client && 
                      project.clientId == authProvider.userModel?.id) {
                    return IconButton(
                      onPressed: () => _editProject(project),
                      icon: const Icon(Icons.edit, color: kAccentTeal),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(width: 8),
              // Review button for completed projects
              if (project.status == ProjectStatus.completed) ...[
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    final currentUser = authProvider.userModel;
                    if (currentUser == null) return const SizedBox.shrink();
                    
                    // Show review button if user is client or freelancer involved in project
                    bool canReview = false;
                    String targetUserId = '';
                    ReviewTarget targetRole = ReviewTarget.freelancer;
                    
                    if (currentUser.role == UserRole.client && project.clientId == currentUser.id) {
                      canReview = true;
                      targetUserId = project.freelancerId ?? '';
                      targetRole = ReviewTarget.freelancer;
                    } else if (currentUser.role == UserRole.freelancer && project.freelancerId == currentUser.id) {
                      canReview = true;
                      targetUserId = project.clientId;
                      targetRole = ReviewTarget.client;
                    }
                    
                    if (canReview && targetUserId.isNotEmpty) {
                      return IconButton(
                        onPressed: () => _leaveReview(project, targetUserId, targetRole),
                        icon: const Icon(Icons.star, color: Colors.amber),
                      );
                    }
                    
                    return const SizedBox.shrink();
                  },
                ),
              ],
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
        color = kAccentTeal;
        label = 'Published';
        break;
      case ProjectStatus.inProgress:
        color = Colors.orange;
        label = 'In Progress';
        break;
      case ProjectStatus.completed:
        color = Colors.green;
        label = 'Completed';
        break;
      case ProjectStatus.draft:
        color = kTextSecondary;
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

  List<ProjectModel> _getFilteredProjects(ProjectProvider projectProvider) {
    List<ProjectModel> projects = [];
    
    switch (widget.listType) {
      case ProjectListType.myProjects:
        projects = projectProvider.myProjects;
        break;
      case ProjectListType.availableProjects:
        projects = projectProvider.availableProjects;
        break;
      case ProjectListType.all:
        projects = projectProvider.projects;
        break;
    }

    // Apply filters
    if (_searchQuery.isNotEmpty) {
      projects = projects.where((project) {
        return project.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               project.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_selectedStatus != null) {
      projects = projects.where((project) => project.status == _selectedStatus).toList();
    }

    return projects;
  }

  void _viewProjectDetails(ProjectModel project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailsScreen(project: project),
      ),
    );
  }

  void _editProject(ProjectModel project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProjectScreen(project: project),
      ),
    );
  }

  void _leaveReview(ProjectModel project, String targetUserId, ReviewTarget targetRole) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewScreen(
          project: project,
          targetUserId: targetUserId,
          targetRole: targetRole,
        ),
      ),
    );
  }
}
