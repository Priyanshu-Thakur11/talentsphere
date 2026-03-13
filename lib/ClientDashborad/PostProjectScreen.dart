import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:nileshapp/ClientDashborad/DashboardScreen.dart';
import 'package:nileshapp/providers/project_provider.dart';
import 'package:nileshapp/providers/auth_provider.dart';
import 'package:nileshapp/models/project_model.dart';

class PostProjectScreen extends StatefulWidget {
  const PostProjectScreen({super.key});

  @override
  State<PostProjectScreen> createState() => _PostProjectScreenState();
}

class _PostProjectScreenState extends State<PostProjectScreen> {
  int currentStep = 1;

  // Step 1 controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  // Step 2 controllers
  final TextEditingController _skillController = TextEditingController();
  final List<String> skills = ['UI/UX Design', 'Flutter Dev', 'React', 'Python', 'AI/ML'];
  final List<String> selectedSkills = [];

  // Step 3 controllers
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  // Step 4: Milestones
  final List<Map<String, dynamic>> milestones = [];

  // Step 5: Attachments
  List<PlatformFile> attachedFiles = [];
  bool isPublished = false;
  bool _isLoading = false;

  void nextStep() {
    if (currentStep < 5) {
      setState(() => currentStep++);
    } else {
      _publishProject();
    }
  }

  void previousStep() {
    if (currentStep > 1) {
      setState(() => currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void addSkill(String skill) {
    if (skill.isNotEmpty && !selectedSkills.contains(skill)) {
      setState(() {
        selectedSkills.add(skill);
        _skillController.clear();
      });
    }
  }

  Future<void> _selectDate(int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: milestones[index]['date'] ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.pinkAccent,
              onPrimary: Colors.white,
              surface: Color(0xFF0A0E21),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => milestones[index]['date'] = picked);
    }
  }

  void addMilestone() {
    setState(() {
      milestones.add({'title': 'Phase ${milestones.length + 1}: ', 'date': null});
    });
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        attachedFiles.addAll(result.files);
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      attachedFiles.removeAt(index);
    });
  }

  // ✅ Save project to Firebase on Publish
  Future<void> _publishProject() async {
    if (_titleController.text.isEmpty || 
        _descController.text.isEmpty || 
        _budgetController.text.isEmpty || 
        _durationController.text.isEmpty) {
      _showErrorSnackBar('Please fill all required fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      
      if (authProvider.userModel == null) {
        _showErrorSnackBar('User not authenticated');
        return;
      }

      // Convert milestones to MilestoneModel
      final milestoneModels = milestones.map((milestone) {
        return MilestoneModel(
          id: const Uuid().v4(),
          title: milestone['title'] ?? 'Milestone',
          description: milestone['title'] ?? '',
          amount: double.tryParse(_budgetController.text) ?? 0.0 / milestones.length,
          dueDate: milestone['date'] ?? DateTime.now().add(const Duration(days: 30)),
        );
      }).toList();

      // Create project model
      final project = ProjectModel(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descController.text,
        clientId: authProvider.userModel!.id,
        type: ProjectType.fixed,
        status: ProjectStatus.published,
        budget: double.tryParse(_budgetController.text) ?? 0.0,
        currency: 'INR',
        duration: int.tryParse(_durationController.text) ?? 0,
        requiredSkills: selectedSkills,
        tags: selectedSkills,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        milestones: milestoneModels,
        attachments: attachedFiles.map((file) => file.name).toList(),
        proposalsCount: 0,
      );

      // Save to Firebase with notifications
      await projectProvider.createProject(project, authProvider.userModel!);

      // Show success message
      setState(() {
        isPublished = true;
        _isLoading = false;
      });

      _showSuccessSnackBar('Project published successfully!');

      // Wait 2 seconds, then navigate back
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ClientDashboardScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to publish project: $e');
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
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Step indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    "Step $currentStep/5",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: currentStep / 5,
                      backgroundColor: Colors.white12,
                      color: Colors.pinkAccent,
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              "Post Project",
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _getCurrentStep(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCurrentStep() {
    switch (currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3(); // ✅ Step 3 added here
      case 4:
        return _buildStep4();
      case 5:
        return _buildStep5();
      default:
        return _buildStep1();
    }
  }

  // ----------------- STEP 1 -----------------
  Widget _buildStep1() => Column(
        key: const ValueKey(1),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Step 1: Basic Details",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _glowTextField(_titleController, "Project Title", Colors.pinkAccent),
          const SizedBox(height: 20),
          _glowTextField(_descController, "Project Description", Colors.cyanAccent, maxLines: 3),
          const Spacer(),
          _bottomButtons(),
        ],
      );

  // ----------------- STEP 2 -----------------
  Widget _buildStep2() => Column(
        key: const ValueKey(2),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Step 2: Skills Required",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _glowTextField(_skillController, "Add Skills", Colors.pinkAccent, suffix: Icons.add,
              onSuffixTap: () => addSkill(_skillController.text)),
          const SizedBox(height: 20),
          Wrap(spacing: 10, runSpacing: 10, children: [
            ...skills.map(_buildSkillChip),
            ...selectedSkills.map(_buildSelectedSkill),
          ]),
          const Spacer(),
          _bottomButtons(),
        ],
      );

  // ----------------- ✅ STEP 3 -----------------
  Widget _buildStep3() => Column(
        key: const ValueKey(3),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Step 3: Budget & Duration",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _glowTextField(_budgetController, "Project Budget (Rupee)", Colors.pinkAccent),
          const SizedBox(height: 20),
          _glowTextField(_durationController, "Estimated Duration (Weeks)", Colors.cyanAccent),
          const Spacer(),
          _bottomButtons(),
        ],
      );

  // ----------------- STEP 4 -----------------
  Widget _buildStep4() => Column(
        key: const ValueKey(4),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Step 4: Milestones",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: milestones.length,
              itemBuilder: (context, index) {
                final milestone = milestones[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.pinkAccent.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) => milestone['title'] = value,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Phase ${index + 1}: Description",
                            hintStyle: const TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today, color: Colors.cyanAccent),
                        onPressed: () => _selectDate(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: addMilestone,
            child: _gradientButton("+ Add Milestone"),
          ),
          const SizedBox(height: 20),
          _bottomButtons(),
        ],
      );

  // ----------------- STEP 5 -----------------
  Widget _buildStep5() => Column(
        key: const ValueKey(5),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Step 5: Attachments & Publish",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _pickFiles,
            child: Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white38, style: BorderStyle.solid, width: 2),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withOpacity(0.05),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload, color: Colors.white, size: 40),
                    SizedBox(height: 10),
                    Text("+ Upload Files", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: attachedFiles.length,
              itemBuilder: (context, index) {
                final file = attachedFiles[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        const Icon(Icons.insert_drive_file, color: Colors.cyanAccent),
                        const SizedBox(width: 8),
                        Text(file.name,
                            style: const TextStyle(color: Colors.white, fontSize: 14)),
                      ]),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white54),
                        onPressed: () => _removeFile(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (isPublished)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.greenAccent),
                  SizedBox(width: 8),
                  Text("Project published successfully!",
                      style: TextStyle(color: Colors.greenAccent)),
                ],
              ),
            ),
          _bottomButtons(
              nextLabel: _isLoading ? "Publishing..." : (isPublished ? "Done" : "Publish Project"),
              gradient: const [Colors.blueAccent, Colors.pinkAccent]),
        ],
      );

  // ----------------- REUSABLE WIDGETS -----------------
  Widget _glowTextField(TextEditingController controller, String hint, Color color,
      {int maxLines = 1, IconData? suffix, VoidCallback? onSuffixTap}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
        boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 12, spreadRadius: 1)],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          suffixIcon: suffix != null
              ? IconButton(icon: Icon(suffix, color: Colors.white70), onPressed: onSuffixTap)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _bottomButtons(
      {String nextLabel = "Next",
      List<Color>? gradient = const [Colors.pinkAccent, Colors.blueAccent]}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _button("Back", onTap: previousStep, color: Colors.white24),
        _gradientButton(nextLabel, onTap: nextStep, gradient: gradient!),
      ],
    );
  }

  Widget _button(String label, {VoidCallback? onTap, Color color = Colors.white12}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
        child: Text(label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _gradientButton(String label,
      {List<Color> gradient = const [Colors.pinkAccent, Colors.blueAccent], VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(30),
        ),
        child:
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildSkillChip(String skill) => GestureDetector(
        onTap: () => addSkill(skill),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.pinkAccent, Colors.blueAccent]),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child:
              Text(skill, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      );

  Widget _buildSelectedSkill(String skill) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.pinkAccent, Colors.blueAccent]),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(skill,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => setState(() => selectedSkills.remove(skill)),
            child: const Icon(Icons.close, size: 16, color: Colors.black),
          ),
        ]),
      );
}