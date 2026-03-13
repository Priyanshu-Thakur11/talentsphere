import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'firebase_service.dart';

class StorageService {
  static StorageService? _instance;
  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  StorageService._();

  final FirebaseStorage _storage = FirebaseService.instance.storage;
  final ImagePicker _imagePicker = ImagePicker();
  final Uuid _uuid = const Uuid();

  // Upload profile image
  Future<String> uploadProfileImage({
    required String userId,
    required File imageFile,
    Function(double)? onProgress,
  }) async {
    try {
      final fileName = 'profile_${_uuid.v4()}${path.extension(imageFile.path)}';
      final ref = _storage.ref('profile_images/$userId/$fileName');
      
      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: _getContentType(imageFile.path),
          customMetadata: {
            'userId': userId,
            'type': 'profile_image',
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (onProgress != null) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        }
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  // Upload project file
  Future<String> uploadProjectFile({
    required String projectId,
    required File file,
    String? description,
    Function(double)? onProgress,
  }) async {
    try {
      final fileName = '${_uuid.v4()}${path.extension(file.path)}';
      final ref = _storage.ref('project_files/$projectId/$fileName');
      
      final uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: _getContentType(file.path),
          customMetadata: {
            'projectId': projectId,
            'type': 'project_file',
            'description': description ?? '',
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (onProgress != null) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        }
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload project file: $e');
    }
  }

  // Upload team logo
  Future<String> uploadTeamLogo({
    required String teamId,
    required File imageFile,
    Function(double)? onProgress,
  }) async {
    try {
      final fileName = 'logo_${_uuid.v4()}${path.extension(imageFile.path)}';
      final ref = _storage.ref('team_logos/$teamId/$fileName');
      
      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: _getContentType(imageFile.path),
          customMetadata: {
            'teamId': teamId,
            'type': 'team_logo',
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (onProgress != null) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        }
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload team logo: $e');
    }
  }

  // Upload resume
  Future<String> uploadResume({
    required String userId,
    required File resumeFile,
    Function(double)? onProgress,
  }) async {
    try {
      final fileName = 'resume_${_uuid.v4()}${path.extension(resumeFile.path)}';
      final ref = _storage.ref('resumes/$userId/$fileName');
      
      final uploadTask = ref.putFile(
        resumeFile,
        SettableMetadata(
          contentType: _getContentType(resumeFile.path),
          customMetadata: {
            'userId': userId,
            'type': 'resume',
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (onProgress != null) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        }
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload resume: $e');
    }
  }

  // Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image from gallery: $e');
    }
  }

  // Pick image from camera
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image from camera: $e');
    }
  }

  // Pick file
  Future<File?> pickFile({
    List<String>? allowedExtensions,
    String? type,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: type != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.path != null) {
          return File(file.path!);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick file: $e');
    }
  }

  // Pick multiple files
  Future<List<File>> pickMultipleFiles({
    List<String>? allowedExtensions,
    String? type,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: type != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files
            .where((file) => file.path != null)
            .map((file) => File(file.path!))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to pick multiple files: $e');
    }
  }

  // Delete file
  Future<void> deleteFile(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  // Get file metadata
  Future<FullMetadata> getFileMetadata(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      return await ref.getMetadata();
    } catch (e) {
      throw Exception('Failed to get file metadata: $e');
    }
  }

  // List files in a folder
  Future<List<Reference>> listFiles(String folderPath) async {
    try {
      final ref = _storage.ref(folderPath);
      final result = await ref.listAll();
      return result.items;
    } catch (e) {
      throw Exception('Failed to list files: $e');
    }
  }

  // Get download URL
  Future<String> getDownloadUrl(String path) async {
    try {
      final ref = _storage.ref(path);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }

  // Upload with custom path
  Future<String> uploadWithCustomPath({
    required String customPath,
    required File file,
    Map<String, String>? customMetadata,
    Function(double)? onProgress,
  }) async {
    try {
      final fileName = '${_uuid.v4()}${path.extension(file.path)}';
      final ref = _storage.ref('$customPath/$fileName');
      
      final uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: _getContentType(file.path),
          customMetadata: customMetadata ?? {},
        ),
      );

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (onProgress != null) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        }
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  // Get content type based on file extension
  String _getContentType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.pdf':
        return 'application/pdf';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case '.txt':
        return 'text/plain';
      case '.zip':
        return 'application/zip';
      case '.mp4':
        return 'video/mp4';
      case '.avi':
        return 'video/x-msvideo';
      case '.mov':
        return 'video/quicktime';
      default:
        return 'application/octet-stream';
    }
  }

  // Get file size in human readable format
  String getFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Check if file type is allowed
  bool isFileTypeAllowed(String fileName, List<String> allowedExtensions) {
    final extension = path.extension(fileName).toLowerCase();
    return allowedExtensions.contains(extension);
  }

  // Get file extension
  String getFileExtension(String fileName) {
    return path.extension(fileName).toLowerCase();
  }

  // Validate file size
  bool isFileSizeValid(File file, int maxSizeInBytes) {
    return file.lengthSync() <= maxSizeInBytes;
  }
}
