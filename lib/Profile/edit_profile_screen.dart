// lib/Profile/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nileshapp/providers/auth_provider.dart';
import 'package:nileshapp/providers/user_provider.dart';
import 'package:nileshapp/services/storage_service.dart'; // 👈 Import StorageService
import 'package:nileshapp/models/user_model.dart';
import 'dart:io';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB);
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  late TextEditingController _websiteController;
  late TextEditingController _hourlyRateController; // 👈 ADDED CONTROLLER
  
  List<String> _skills = [];
  TextEditingController _skillController = TextEditingController();
  
  String? _resumeFileName; // 👈 Resume file name
  File? _selectedResumeFile; // 👈 Actual File object
  
  File? _selectedProfileImage; // 👈 Profile image file
  String? _profileImageUrl; // 👈 Current profile image URL
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.userModel;
    
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _locationController = TextEditingController(text: user?.location ?? '');
    _websiteController = TextEditingController(text: '');
    _hourlyRateController = TextEditingController(text: user?.hourlyRate?.toString() ?? ''); // 👈 INIT CONTROLLER
    _skills = List.from(user?.skills ?? []);

    _resumeFileName = user?.resumeUrl != null ? 'Resume.pdf' : null; // Use a generic name if URL exists
    _profileImageUrl = user?.profileImageUrl; // Set current profile image URL
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _hourlyRateController.dispose(); // 👈 DISPOSE CONTROLLER
    _skillController.dispose();
    super.dispose();
  }

  // 👈 ADDED METHOD
  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.path != null) {
        setState(() {
          _selectedResumeFile = File(file.path!);
          _resumeFileName = file.name;
        });
      }
    }
  }

  // 👈 ADDED METHOD - Pick profile image
  Future<void> _pickProfileImage() async {
    try {
      final storageService = StorageService.instance;
      final imageFile = await storageService.pickImageFromGallery();
      
      if (imageFile != null) {
        setState(() {
          _selectedProfileImage = imageFile;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  Future<void> _updateProfile() async {
    if (_nameController.text.isEmpty) {
      _showErrorSnackBar('Name is required');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final storageService = StorageService.instance; // 👈 Use StorageService
      
      if (authProvider.userModel == null) {
        _showErrorSnackBar('User not found');
        return;
      }

      String? newResumeUrl = authProvider.userModel!.resumeUrl;
      String? newProfileImageUrl = authProvider.userModel!.profileImageUrl;

      // 👈 Handle Profile Image Upload
      if (_selectedProfileImage != null && authProvider.userModel!.id.isNotEmpty) {
        _showSuccessSnackBar('Uploading profile image...');
        newProfileImageUrl = await storageService.uploadProfileImage(
          userId: authProvider.userModel!.id,
          imageFile: _selectedProfileImage!,
        );
      }

      // 👈 Handle Resume Upload
      if (_selectedResumeFile != null && authProvider.userModel!.id.isNotEmpty) {
        _showSuccessSnackBar('Uploading resume...');
        newResumeUrl = await storageService.uploadResume(
          userId: authProvider.userModel!.id,
          resumeFile: _selectedResumeFile!,
        );
      }

      // Create updated user model
      final updatedUser = authProvider.userModel!.copyWith(
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        bio: _bioController.text,
        location: _locationController.text,
        skills: _skills,
        hourlyRate: double.tryParse(_hourlyRateController.text), // 👈 SAVE HOURLY RATE
        resumeUrl: newResumeUrl, // 👈 SAVE RESUME URL
        profileImageUrl: newProfileImageUrl, // 👈 SAVE PROFILE IMAGE URL
        updatedAt: DateTime.now(),
      );

      // Update in Firebase
      await userProvider.updateUser(updatedUser);
      
      // Update local auth provider (This happens implicitly if AuthProvider listens to UserProvider or Firestore)
      // but for immediate UI consistency, we rely on state management.

      _showSuccessSnackBar('Profile updated successfully!');

      // Navigate back
      Navigator.pop(context);
      
    } catch (e) {
      _showErrorSnackBar('Failed to update profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addSkill() {
    if (_skillController.text.isNotEmpty && !_skills.contains(_skillController.text)) {
      setState(() {
        _skills.add(_skillController.text);
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
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
    // Determine if the current user is a Freelancer to show the relevant fields
    final isFreelancer = Provider.of<AuthProvider>(context).userModel?.role == UserRole.freelancer;

    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: AppBar(
        backgroundColor: kDarkBackground,
        elevation: 0,
        title: const Text(
          'Edit Profile',
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
              onPressed: _updateProfile,
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
                  // Basic Information
                  _buildSectionTitle('Basic Information'),
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    icon: Icons.person,
                    isRequired: true,
                  ),
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email,
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    controller: _bioController,
                    label: 'Bio',
                    icon: Icons.info,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  
                  // Profile Image Upload Section
                  _buildProfileImageSection(),
                  const SizedBox(height: 24),
                  
                  // Freelancer Specific Fields (Hourly Rate and Resume)
                  if (isFreelancer) ...[ // 👈 Conditional UI for Freelancer
                    _buildSectionTitle('Freelancer Details'),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _hourlyRateController,
                      label: 'Hourly Rate (\$/hr)',
                      icon: Icons.money_rounded,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    _buildResumeUploadSection(), // 👈 NEW RESUME SECTION
                    const SizedBox(height: 24),
                  ],

                  // Location & Website
                  _buildSectionTitle('Location'),
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    controller: _locationController,
                    label: 'Location',
                    icon: Icons.location_on,
                  ),
                  const SizedBox(height: 24),
                  
                  // Skills Section
                  _buildSectionTitle('Skills'),
                  const SizedBox(height: 16),
                  
                  _buildSkillsSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile Picture',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Profile Image Preview
            GestureDetector(
              onTap: _pickProfileImage,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: kPrimaryPurple.withOpacity(0.3),
                  ),
                ),
                child: _selectedProfileImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedProfileImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : _profileImageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _profileImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  color: kTextSecondary,
                                  size: 40,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.add_a_photo,
                            color: kTextSecondary,
                            size: 30,
                          ),
              ),
            ),
            const SizedBox(width: 16),
            // Upload Button and Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: kAccentTeal.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: kAccentTeal.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.upload,
                            color: kAccentTeal,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Upload Photo',
                            style: TextStyle(
                              color: kAccentTeal,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to change profile picture',
                    style: TextStyle(
                      color: kTextSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResumeUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resume/CV (PDF, DOCX)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickResume, // 👈 Triggers file picker
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: kCardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _resumeFileName != null ? kAccentTeal : kPrimaryPurple.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _resumeFileName ?? 'Click to upload resume...',
                    style: TextStyle(
                      color: _resumeFileName != null ? Colors.white : kTextSecondary,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  _resumeFileName != null ? Icons.check_circle : Icons.upload_file,
                  color: _resumeFileName != null ? kAccentTeal : kTextSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
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
    required String label,
    required IconData icon,
    bool isRequired = false,
    bool enabled = true,
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
        enabled: enabled,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: TextStyle(
          color: enabled ? Colors.white : kTextSecondary,
        ),
        decoration: InputDecoration(
          labelText: label + (isRequired ? ' *' : ''),
          labelStyle: TextStyle(
            color: enabled ? kTextSecondary : kTextSecondary.withOpacity(0.5),
          ),
          prefixIcon: Icon(icon, color: kTextSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add skill input
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: kDarkBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kTextSecondary.withOpacity(0.3)),
                  ),
                  child: TextField(
                    controller: _skillController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Add a skill',
                      hintStyle: TextStyle(color: kTextSecondary),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onSubmitted: (_) => _addSkill(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addSkill,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Skills list
          if (_skills.isNotEmpty) ...[
            const Text(
              'Your Skills:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _skills.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: kAccentTeal.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kAccentTeal.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        skill,
                        style: const TextStyle(
                          color: kAccentTeal,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => _removeSkill(skill),
                        child: Icon(
                          Icons.close,
                          color: kAccentTeal,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
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
    );
  }
}