// lib/Projects/project_details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nileshapp/providers/project_provider.dart';
import 'package:nileshapp/providers/auth_provider.dart';
import 'package:nileshapp/models/project_model.dart';
import 'package:nileshapp/models/user_model.dart';
import 'package:nileshapp/Projects/edit_project_screen.dart';
import 'package:nileshapp/Projects/review_submission_screen.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB);
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;

class ProjectDetailsScreen extends StatelessWidget {
  final ProjectModel project;
  
  const ProjectDetailsScreen({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.userModel;
    final isFreelancer = currentUser?.role == UserRole.freelancer;
    final isClient = currentUser?.role == UserRole.client;
    final isProjectOwner = isClient && project.clientId == currentUser?.id;
    final isProjectCompleted = project.status == ProjectStatus.completed;
    final hasFreelancer = project.freelancerId != null;

    // Review logic
    final bool canClientReviewFreelancer =
        isProjectCompleted && isClient && isProjectOwner && hasFreelancer;
    final bool canFreelancerReviewClient =
        isProjectCompleted && isFreelancer && project.freelancerId == currentUser?.id;

    return Scaffold(
      backgroundColor: kDarkBackground,
      body: Stack(
        children: [
          // Background gradient
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
                _buildAppBar(context, isProjectOwner),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProjectHeader(),
                        const SizedBox(height: 24),

                        // Review Section (for completed projects)
                        //if (canClientReviewFreelancer || canFreelancerReviewClient)
                        _buildReviewSection(context, currentUser),
                        
                        const SizedBox(height: 24),
                        _buildProjectInfo(),
                        const SizedBox(height: 24),
                        _buildSkillsSection(),
                        const SizedBox(height: 24),
                        _buildMilestonesSection(),
                        const SizedBox(height: 24),
                        _buildProjectStats(),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),

                // Submit Proposal Button (for freelancers)
                if (isFreelancer && project.status == ProjectStatus.published)
                  _buildSubmitProposalButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- App Bar ---
  Widget _buildAppBar(BuildContext context, bool isProjectOwner) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          if (isProjectOwner)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProjectScreen(project: project),
                  ),
                );
              },
              icon: const Icon(Icons.edit, color: kAccentTeal),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }

  // --- Review Section ---
  Widget _buildReviewSection(BuildContext context, UserModel? currentUser) {
    if (currentUser == null) return const SizedBox.shrink();

    final isClient = currentUser.role == UserRole.client;
    final isFreelancer = currentUser.role == UserRole.freelancer;

    if (isClient && project.freelancerId != null) {
      return _buildReviewButton(
        context,
        label: 'Review Freelancer',
        receiverId: project.freelancerId!,
        receiverRole: ReviewTarget.freelancer,
      );
    }

    if (isFreelancer && project.freelancerId == currentUser.id) {
      return _buildReviewButton(
        context,
        label: 'Review Client',
        receiverId: project.clientId,
        receiverRole: ReviewTarget.client,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildReviewButton(
    BuildContext context, {
    required String label,
    required String receiverId,
    required ReviewTarget receiverRole,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewSubmissionScreen(
                project: project,
                receiverId: receiverId,
                receiverRole: receiverRole,
              ),
            ),
          );
        },
        icon: const Icon(Icons.star_rate_rounded, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: kAccentPink,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // --- Submit Proposal Button ---
  Widget _buildSubmitProposalButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kAccentTeal, kPrimaryPurple],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: kAccentTeal.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Submit Proposal Screen Coming Soon!')),
            );
          },
          child: const Text(
            'Submit Proposal',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  // --- Project Header ---
  Widget _buildProjectHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: kPrimaryPurple.withOpacity(0.2)),
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildStatusChip(project.status),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            project.description,
            style: TextStyle(
              color: kTextSecondary,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // --- Info Section ---
  Widget _buildProjectInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: kPrimaryPurple.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Project Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.attach_money, 'Budget', '₹${project.budget.toStringAsFixed(0)}'),
          _buildInfoRow(Icons.schedule, 'Duration', '${project.duration} days'),
          _buildInfoRow(Icons.people, 'Proposals', '${project.proposalsCount} proposals'),
          _buildInfoRow(Icons.calendar_today, 'Created', _formatDate(project.createdAt)),
          if (project.deadline != null)
            _buildInfoRow(Icons.event, 'Deadline', _formatDate(project.deadline!)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: kAccentTeal, size: 20),
          const SizedBox(width: 12),
          Text('$label: ', style: TextStyle(color: kTextSecondary, fontSize: 14)),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // --- Skills ---
  Widget _buildSkillsSection() {
    if (project.requiredSkills.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: kPrimaryPurple.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Required Skills', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: project.requiredSkills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: kAccentTeal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(skill, style: const TextStyle(color: kAccentTeal, fontSize: 14)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- Milestones ---
  Widget _buildMilestonesSection() {
    if (project.milestones.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: kPrimaryPurple.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Project Milestones', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...project.milestones.map((milestone) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kDarkBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: milestone.isCompleted ? Colors.green.withOpacity(0.3) : kTextSecondary.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    milestone.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: milestone.isCompleted ? Colors.green : kTextSecondary,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(milestone.title,
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                        if (milestone.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(milestone.description, style: TextStyle(color: kTextSecondary, fontSize: 14)),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, color: kTextSecondary, size: 16),
                            const SizedBox(width: 4),
                            Text('Due: ${_formatDate(milestone.dueDate)}',
                                style: TextStyle(color: kTextSecondary, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text('₹${milestone.amount.toStringAsFixed(0)}',
                      style: const TextStyle(color: kAccentTeal, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // --- Stats ---
  Widget _buildProjectStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: kPrimaryPurple.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Project Statistics', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatCard('Total Milestones', '${project.milestones.length}', Icons.flag, kAccentTeal)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Completed', '${project.milestones.where((m) => m.isCompleted).length}', Icons.check_circle, Colors.green)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatCard('Proposals', '${project.proposalsCount}', Icons.people, kPrimaryPurple)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Attachments', '${project.attachments.length}', Icons.attach_file, kAccentPink)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kDarkBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: kTextSecondary, fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // --- Status Chip ---
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
