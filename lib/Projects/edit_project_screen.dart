import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:nileshapp/providers/project_provider.dart';
import 'package:nileshapp/providers/auth_provider.dart';
import 'package:nileshapp/models/project_model.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB);
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;

class EditProjectScreen extends StatefulWidget {
  final ProjectModel project;
  
  const EditProjectScreen({
    super.key,
    required this.project,
  });

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _budgetController;
  late TextEditingController _durationController;
  
  ProjectStatus _selectedStatus = ProjectStatus.published;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project.title);
    _descriptionController = TextEditingController(text: widget.project.description);
    _budgetController = TextEditingController(text: widget.project.budget.toString());
    _durationController = TextEditingController(text: widget.project.duration.toString());
    _selectedStatus = widget.project.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _updateProject() async {
    if (_titleController.text.isEmpty || 
        _descriptionController.text.isEmpty || 
        _budgetController.text.isEmpty || 
        _durationController.text.isEmpty) {
      _showErrorSnackBar('Please fill all required fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      
      // Create updated project
      final updatedProject = widget.project.copyWith(
        title: _titleController.text,
        description: _descriptionController.text,
        budget: double.tryParse(_budgetController.text) ?? widget.project.budget,
        duration: int.tryParse(_durationController.text) ?? widget.project.duration,
        status: _selectedStatus,
        updatedAt: DateTime.now(),
      );

      // Update in Firebase
      await projectProvider.updateProject(updatedProject);

      _showSuccessSnackBar('Project updated successfully!');

      // Navigate back
      Navigator.pop(context);
      
    } catch (e) {
      _showErrorSnackBar('Failed to update project: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: AppBar(
        backgroundColor: kDarkBackground,
        elevation: 0,
        title: const Text(
          'Edit Project',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: kPrimaryPurple,
                  strokeWidth: 2,
                ),
              ),
            )
          else
            TextButton(
              onPressed: _updateProject,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: kPrimaryPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project Title
                  _buildSectionTitle('Project Title'),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _titleController,
                    hintText: 'Enter project title',
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 24),
                  
                  // Project Description
                  _buildSectionTitle('Project Description'),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _descriptionController,
                    hintText: 'Enter project description',
                    icon: Icons.description,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 24),
                  
                  // Budget and Duration Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Budget (₹)'),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _budgetController,
                              hintText: 'Enter budget',
                              icon: Icons.attach_money,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Duration (Days)'),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _durationController,
                              hintText: 'Enter duration',
                              icon: Icons.schedule,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Project Status
                  _buildSectionTitle('Project Status'),
                  const SizedBox(height: 12),
                  _buildStatusSelector(),
                  const SizedBox(height: 24),
                  
                  // Skills Section
                  _buildSectionTitle('Required Skills'),
                  const SizedBox(height: 12),
                  _buildSkillsSection(),
                  const SizedBox(height: 24),
                  
                  // Milestones Section
                  _buildSectionTitle('Milestones'),
                  const SizedBox(height: 12),
                  _buildMilestonesSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPrimaryPurple.withOpacity(0.3)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: kTextSecondary),
          prefixIcon: Icon(icon, color: kTextSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildStatusSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPrimaryPurple.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ProjectStatus>(
          value: _selectedStatus,
          isExpanded: true,
          dropdownColor: kCardColor,
          style: const TextStyle(color: Colors.white),
          items: ProjectStatus.values.map((status) {
            String label;
            switch (status) {
              case ProjectStatus.draft:
                label = 'Draft';
                break;
              case ProjectStatus.published:
                label = 'Published';
                break;
              case ProjectStatus.inProgress:
                label = 'In Progress';
                break;
              case ProjectStatus.completed:
                label = 'Completed';
                break;
              case ProjectStatus.cancelled:
                label = 'Cancelled';
                break;
              case ProjectStatus.disputed:
                label = 'Disputed';
                break;
            }
            return DropdownMenuItem(
              value: status,
              child: Text(label),
            );
          }).toList(),
          onChanged: (ProjectStatus? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedStatus = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPrimaryPurple.withOpacity(0.3)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: widget.project.requiredSkills.map((skill) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: kAccentTeal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              skill,
              style: const TextStyle(
                color: kAccentTeal,
                fontSize: 14,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMilestonesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPrimaryPurple.withOpacity(0.3)),
      ),
      child: Column(
        children: widget.project.milestones.map((milestone) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kDarkBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  milestone.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: milestone.isCompleted ? Colors.green : kTextSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        milestone.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Due: ${milestone.dueDate.day}/${milestone.dueDate.month}/${milestone.dueDate.year}',
                        style: TextStyle(
                          color: kTextSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹${milestone.amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: kAccentTeal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
