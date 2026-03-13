import '../models/project_model.dart';

class AIService {
  static AIService? _instance;
  static AIService get instance {
    _instance ??= AIService._();
    return _instance!;
  }

  AIService._();

  // Analyze resume using ML Kit
  Future<ResumeAnalysisResult> analyzeResume(String resumeText) async {
    try {
      // Extract skills using text recognition
      final skills = await _extractSkills(resumeText);
      
      // Extract experience level
      final experienceLevel = _extractExperienceLevel(resumeText);
      
      // Extract education
      final education = _extractEducation(resumeText);
      
      // Calculate match score
      final matchScore = _calculateMatchScore(skills, experienceLevel);
      
      return ResumeAnalysisResult(
        skills: skills,
        experienceLevel: experienceLevel,
        education: education,
        matchScore: matchScore,
        suggestions: _generateSuggestions(skills, experienceLevel),
      );
    } catch (e) {
      throw Exception('Failed to analyze resume: $e');
    }
  }

  // Extract skills from resume text
  Future<List<String>> _extractSkills(String resumeText) async {
    try {
      // Common technical skills to look for
      final skillKeywords = [
        'Flutter', 'Dart', 'React', 'Vue', 'Angular', 'JavaScript', 'TypeScript',
        'Python', 'Java', 'C++', 'C#', 'PHP', 'Ruby', 'Go', 'Swift', 'Kotlin',
        'HTML', 'CSS', 'Bootstrap', 'Tailwind', 'SASS', 'SCSS',
        'Node.js', 'Express', 'Django', 'Flask', 'Spring', 'Laravel', 'Rails',
        'MySQL', 'PostgreSQL', 'MongoDB', 'Redis', 'Firebase', 'Supabase',
        'AWS', 'Azure', 'Google Cloud', 'Docker', 'Kubernetes', 'Jenkins',
        'Git', 'GitHub', 'GitLab', 'Bitbucket', 'Jira', 'Confluence',
        'Figma', 'Sketch', 'Adobe XD', 'Photoshop', 'Illustrator',
        'Machine Learning', 'AI', 'Data Science', 'TensorFlow', 'PyTorch',
        'Blockchain', 'Web3', 'Solidity', 'Smart Contracts',
        'Mobile Development', 'iOS', 'Android', 'React Native', 'Xamarin',
        'UI/UX Design', 'User Experience', 'User Interface', 'Wireframing',
        'Project Management', 'Agile', 'Scrum', 'Kanban', 'JIRA',
        'DevOps', 'CI/CD', 'Testing', 'Unit Testing', 'Integration Testing',
      ];

      final extractedSkills = <String>[];
      final lowerText = resumeText.toLowerCase();

      for (final skill in skillKeywords) {
        if (lowerText.contains(skill.toLowerCase())) {
          extractedSkills.add(skill);
        }
      }

      return extractedSkills;
    } catch (e) {
      throw Exception('Failed to extract skills: $e');
    }
  }

  // Extract experience level from resume text
  ExperienceLevel _extractExperienceLevel(String resumeText) {
    final lowerText = resumeText.toLowerCase();
    
    // Look for experience indicators
    if (lowerText.contains('senior') || lowerText.contains('lead') || lowerText.contains('principal')) {
      return ExperienceLevel.senior;
    } else if (lowerText.contains('junior') || lowerText.contains('entry') || lowerText.contains('graduate')) {
      return ExperienceLevel.junior;
    } else if (lowerText.contains('mid') || lowerText.contains('intermediate')) {
      return ExperienceLevel.mid;
    } else {
      // Try to extract years of experience
      final yearsRegex = RegExp(r'(\d+)\s*(?:years?|yrs?)\s*(?:of\s*)?experience', caseSensitive: false);
      final match = yearsRegex.firstMatch(lowerText);
      
      if (match != null) {
        final years = int.tryParse(match.group(1) ?? '0') ?? 0;
        if (years >= 5) return ExperienceLevel.senior;
        if (years >= 2) return ExperienceLevel.mid;
        return ExperienceLevel.junior;
      }
      
      return ExperienceLevel.mid; // Default to mid-level
    }
  }

  // Extract education information
  List<String> _extractEducation(String resumeText) {
    final education = <String>[];
    final lowerText = resumeText.toLowerCase();
    
    // Look for degree keywords
    final degreeKeywords = [
      'bachelor', 'master', 'phd', 'doctorate', 'associate', 'diploma',
      'certificate', 'certification', 'degree', 'education'
    ];
    
    for (final keyword in degreeKeywords) {
      if (lowerText.contains(keyword)) {
        // Extract the line containing the degree
        final lines = resumeText.split('\n');
        for (final line in lines) {
          if (line.toLowerCase().contains(keyword)) {
            education.add(line.trim());
          }
        }
      }
    }
    
    return education;
  }

  // Calculate match score based on skills and experience
  double _calculateMatchScore(List<String> skills, ExperienceLevel experienceLevel) {
    // Base score from experience level
    double score = switch (experienceLevel) {
      ExperienceLevel.junior => 0.6,
      ExperienceLevel.mid => 0.8,
      ExperienceLevel.senior => 0.9,
    };
    
    // Bonus for number of skills
    final skillBonus = (skills.length * 0.02).clamp(0.0, 0.2);
    score += skillBonus;
    
    return score.clamp(0.0, 1.0);
  }

  // Generate suggestions for improvement
  List<String> _generateSuggestions(List<String> skills, ExperienceLevel experienceLevel) {
    final suggestions = <String>[];
    
    // Suggest missing popular skills
    final popularSkills = [
      'Git', 'Docker', 'AWS', 'JavaScript', 'Python', 'React', 'Node.js'
    ];
    
    for (final skill in popularSkills) {
      if (!skills.any((s) => s.toLowerCase().contains(skill.toLowerCase()))) {
        suggestions.add('Consider learning $skill to increase your marketability');
      }
    }
    
    // Experience-based suggestions
    switch (experienceLevel) {
      case ExperienceLevel.junior:
        suggestions.add('Focus on building a strong portfolio with diverse projects');
        suggestions.add('Consider contributing to open source projects');
        break;
      case ExperienceLevel.mid:
        suggestions.add('Develop leadership and mentoring skills');
        suggestions.add('Consider specializing in a specific technology stack');
        break;
      case ExperienceLevel.senior:
        suggestions.add('Consider learning system architecture and design patterns');
        suggestions.add('Develop expertise in team leadership and project management');
        break;
    }
    
    return suggestions;
  }

  // Match freelancers to projects
  Future<List<ProjectMatch>> matchProjectsToFreelancer({
    required String freelancerId,
    required List<String> freelancerSkills,
    required ExperienceLevel experienceLevel,
    int limit = 10,
  }) async {
    try {
      // This would typically query your database for projects
      // For now, we'll return mock data
      final projects = await _getAvailableProjects();
      
      final matches = <ProjectMatch>[];
      
      for (final project in projects) {
        final matchScore = _calculateProjectMatchScore(
          freelancerSkills,
          experienceLevel,
          project,
        );
        
        if (matchScore > 0.3) { // Only include projects with decent match
          matches.add(ProjectMatch(
            project: project,
            matchScore: matchScore,
            reasons: _getMatchReasons(freelancerSkills, project),
          ));
        }
      }
      
      // Sort by match score and return top matches
      matches.sort((a, b) => b.matchScore.compareTo(a.matchScore));
      return matches.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to match projects: $e');
    }
  }

  // Calculate project match score
  double _calculateProjectMatchScore(
    List<String> freelancerSkills,
    ExperienceLevel experienceLevel,
    ProjectModel project,
  ) {
    double score = 0.0;
    
    // Skill matching
    final skillMatches = project.requiredSkills
        .where((skill) => freelancerSkills.any((fs) => 
            fs.toLowerCase().contains(skill.toLowerCase()) ||
            skill.toLowerCase().contains(fs.toLowerCase())))
        .length;
    
    if (project.requiredSkills.isNotEmpty) {
      score += (skillMatches / project.requiredSkills.length) * 0.7;
    }
    
    // Experience level matching
    final experienceScore = _getExperienceScore(experienceLevel, project);
    score += experienceScore * 0.3;
    
    return score.clamp(0.0, 1.0);
  }

  // Get experience score for project
  double _getExperienceScore(ExperienceLevel freelancerLevel, ProjectModel project) {
    // This is a simplified scoring system
    // In reality, you'd analyze project complexity, budget, etc.
    return switch (freelancerLevel) {
      ExperienceLevel.junior => 0.6,
      ExperienceLevel.mid => 0.8,
      ExperienceLevel.senior => 0.9,
    };
  }

  // Get match reasons
  List<String> _getMatchReasons(List<String> freelancerSkills, ProjectModel project) {
    final reasons = <String>[];
    
    // Skill matches
    final skillMatches = project.requiredSkills
        .where((skill) => freelancerSkills.any((fs) => 
            fs.toLowerCase().contains(skill.toLowerCase())))
        .toList();
    
    if (skillMatches.isNotEmpty) {
      reasons.add('You have experience with: ${skillMatches.join(', ')}');
    }
    
    // Budget considerations
    if (project.budget > 5000) {
      reasons.add('High-budget project with good earning potential');
    }
    
    // Project type
    if (project.type == ProjectType.fixed) {
      reasons.add('Fixed-price project with clear deliverables');
    }
    
    return reasons;
  }

  // Get available projects (mock data)
  Future<List<ProjectModel>> _getAvailableProjects() async {
    // This would typically query your database
    // For now, return empty list
    return [];
  }

  // Estimate project cost using AI
  Future<ProjectEstimate> estimateProjectCost({
    required String projectDescription,
    required List<String> requiredSkills,
    required ProjectType type,
    int? estimatedHours,
  }) async {
    try {
      // Analyze project complexity
      final complexity = _analyzeProjectComplexity(projectDescription, requiredSkills);
      
      // Calculate base cost
      double baseCost = _calculateBaseCost(complexity, requiredSkills);
      
      // Adjust for project type
      if (type == ProjectType.hourly) {
        baseCost = estimatedHours != null ? baseCost * estimatedHours : baseCost * 40;
      }
      
      // Add complexity multiplier
      final complexityMultiplier = switch (complexity) {
        ProjectComplexity.simple => 1.0,
        ProjectComplexity.medium => 1.5,
        ProjectComplexity.complex => 2.0,
        ProjectComplexity.enterprise => 3.0,
      };
      
      final estimatedCost = baseCost * complexityMultiplier;
      
      // Calculate timeline
      final timeline = _calculateTimeline(complexity, requiredSkills);
      
      return ProjectEstimate(
        estimatedCost: estimatedCost,
        complexity: complexity,
        timeline: timeline,
        confidence: _calculateConfidence(projectDescription, requiredSkills),
        breakdown: _generateCostBreakdown(requiredSkills, complexity),
      );
    } catch (e) {
      throw Exception('Failed to estimate project cost: $e');
    }
  }

  // Analyze project complexity
  ProjectComplexity _analyzeProjectComplexity(String description, List<String> skills) {
    final lowerDesc = description.toLowerCase();
    
    // Enterprise indicators
    if (lowerDesc.contains('enterprise') || lowerDesc.contains('scalable') || 
        lowerDesc.contains('microservices') || lowerDesc.contains('distributed')) {
      return ProjectComplexity.enterprise;
    }
    
    // Complex indicators
    if (lowerDesc.contains('ai') || lowerDesc.contains('machine learning') ||
        lowerDesc.contains('blockchain') || lowerDesc.contains('real-time') ||
        skills.any((s) => s.toLowerCase().contains('ai') || s.toLowerCase().contains('ml'))) {
      return ProjectComplexity.complex;
    }
    
    // Simple indicators
    if (lowerDesc.contains('simple') || lowerDesc.contains('basic') ||
        lowerDesc.contains('landing page') || lowerDesc.contains('static')) {
      return ProjectComplexity.simple;
    }
    
    return ProjectComplexity.medium;
  }

  // Calculate base cost
  double _calculateBaseCost(ProjectComplexity complexity, List<String> skills) {
    final baseRates = {
      'Flutter': 50.0,
      'React': 45.0,
      'Python': 40.0,
      'JavaScript': 35.0,
      'UI/UX': 60.0,
      'Mobile': 55.0,
      'Web': 40.0,
    };
    
    double totalRate = 0;
    int skillCount = 0;
    
    for (final skill in skills) {
      for (final rate in baseRates.entries) {
        if (skill.toLowerCase().contains(rate.key.toLowerCase())) {
          totalRate += rate.value;
          skillCount++;
          break;
        }
      }
    }
    
    final avgRate = skillCount > 0 ? totalRate / skillCount : 40.0;
    
    return switch (complexity) {
      ProjectComplexity.simple => avgRate * 20,
      ProjectComplexity.medium => avgRate * 40,
      ProjectComplexity.complex => avgRate * 80,
      ProjectComplexity.enterprise => avgRate * 160,
    };
  }

  // Calculate timeline
  Duration _calculateTimeline(ProjectComplexity complexity, List<String> skills) {
    final baseDays = switch (complexity) {
      ProjectComplexity.simple => 7,
      ProjectComplexity.medium => 21,
      ProjectComplexity.complex => 45,
      ProjectComplexity.enterprise => 90,
    };
    
    // Add time for each additional skill
    final additionalDays = skills.length * 2;
    
    return Duration(days: baseDays + additionalDays);
  }

  // Calculate confidence score
  double _calculateConfidence(String description, List<String> skills) {
    double confidence = 0.5; // Base confidence
    
    // Increase confidence for detailed descriptions
    if (description.length > 100) confidence += 0.1;
    if (description.length > 300) confidence += 0.1;
    
    // Increase confidence for specific skills
    if (skills.length > 3) confidence += 0.1;
    if (skills.length > 5) confidence += 0.1;
    
    return confidence.clamp(0.0, 1.0);
  }

  // Generate cost breakdown
  Map<String, double> _generateCostBreakdown(List<String> skills, ProjectComplexity complexity) {
    final breakdown = <String, double>{};
    
    for (final skill in skills) {
      breakdown[skill] = _getSkillRate(skill) * _getComplexityMultiplier(complexity);
    }
    
    return breakdown;
  }

  // Get skill rate
  double _getSkillRate(String skill) {
    final rates = {
      'Flutter': 50.0,
      'React': 45.0,
      'Python': 40.0,
      'JavaScript': 35.0,
      'UI/UX': 60.0,
      'Mobile': 55.0,
      'Web': 40.0,
    };
    
    for (final rate in rates.entries) {
      if (skill.toLowerCase().contains(rate.key.toLowerCase())) {
        return rate.value;
      }
    }
    
    return 40.0; // Default rate
  }

  // Get complexity multiplier
  double _getComplexityMultiplier(ProjectComplexity complexity) {
    return switch (complexity) {
      ProjectComplexity.simple => 1.0,
      ProjectComplexity.medium => 1.2,
      ProjectComplexity.complex => 1.5,
      ProjectComplexity.enterprise => 2.0,
    };
  }
}

// Enums and classes for AI service
enum ExperienceLevel { junior, mid, senior }
enum ProjectComplexity { simple, medium, complex, enterprise }

class ResumeAnalysisResult {
  final List<String> skills;
  final ExperienceLevel experienceLevel;
  final List<String> education;
  final double matchScore;
  final List<String> suggestions;

  ResumeAnalysisResult({
    required this.skills,
    required this.experienceLevel,
    required this.education,
    required this.matchScore,
    required this.suggestions,
  });
}

class ProjectMatch {
  final ProjectModel project;
  final double matchScore;
  final List<String> reasons;

  ProjectMatch({
    required this.project,
    required this.matchScore,
    required this.reasons,
  });
}

class ProjectEstimate {
  final double estimatedCost;
  final ProjectComplexity complexity;
  final Duration timeline;
  final double confidence;
  final Map<String, double> breakdown;

  ProjectEstimate({
    required this.estimatedCost,
    required this.complexity,
    required this.timeline,
    required this.confidence,
    required this.breakdown,
  });
}
