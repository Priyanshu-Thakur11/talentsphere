# TalentSphere - Complete Backend Integration Setup

## 🚀 Overview

This document provides comprehensive instructions for setting up the complete backend integration for the TalentSphere Flutter application with Firebase, real-time data persistence, and all required services.

## 📋 Prerequisites

- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Firebase CLI
- Google Cloud Console account
- Stripe account (for payments)
- Android Studio / Xcode (for mobile development)

## 🔧 Firebase Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Name it `talentsphere-app`
4. Enable Google Analytics (optional)
5. Create the project

### 2. Enable Authentication

1. In Firebase Console, go to "Authentication" > "Sign-in method"
2. Enable the following providers:
   - Email/Password
   - Google
3. Add authorized domains for your app

### 3. Create Firestore Database

1. Go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location close to your users

### 4. Configure Storage

1. Go to "Storage"
2. Click "Get started"
3. Choose "Start in test mode"
4. Select the same location as Firestore

### 5. Get Configuration Files

#### For Android:
1. Go to Project Settings > General
2. Add Android app
3. Package name: `com.talentsphere.app`
4. Download `google-services.json`
5. Place it in `android/app/`

#### For iOS:
1. Add iOS app
2. Bundle ID: `com.talentsphere.app`
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/`

#### For Web:
1. Add Web app
2. Register app
3. Copy the configuration object

### 6. Update Firebase Options

Update `lib/firebase_options.dart` with your actual configuration:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'your-actual-web-api-key',
  appId: 'your-actual-web-app-id',
  messagingSenderId: 'your-actual-sender-id',
  projectId: 'talentsphere-app',
  authDomain: 'talentsphere-app.firebaseapp.com',
  storageBucket: 'talentsphere-app.appspot.com',
);
```

## 💳 Stripe Payment Setup

### 1. Create Stripe Account

1. Go to [Stripe Dashboard](https://dashboard.stripe.com/)
2. Create an account
3. Get your publishable and secret keys

### 2. Configure Stripe Keys

Update the payment service with your Stripe keys:

```dart
// In lib/services/payment_service.dart
await initializeStripe(
  publishableKey: 'pk_test_your_publishable_key_here',
);
```

## 🔐 Firestore Security Rules

Create the following security rules in Firestore:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Projects - users can read published projects, write their own
    match /projects/{projectId} {
      allow read: if resource.data.status == 'published';
      allow write: if request.auth != null && 
        (request.auth.uid == resource.data.clientId || 
         request.auth.uid == resource.data.freelancerId);
    }
    
    // Teams - members can read/write team data
    match /teams/{teamId} {
      allow read, write: if request.auth != null && 
        request.auth.uid in resource.data.members[].userId;
    }
    
    // Payments - users can read their own payments
    match /payments/{paymentId} {
      allow read: if request.auth != null && 
        (request.auth.uid == resource.data.fromUserId || 
         request.auth.uid == resource.data.toUserId);
    }
    
    // Notifications - users can read their own notifications
    match /notifications/{notificationId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
  }
}
```

## 📱 Mobile Configuration

### Android Setup

1. Add to `android/app/build.gradle`:
```gradle
android {
    compileSdkVersion 34
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

2. Add permissions to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### iOS Setup

1. Add to `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to take profile photos</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to select images</string>
```

## 🔔 Push Notifications Setup

### Android

1. Add to `android/app/build.gradle`:
```gradle
dependencies {
    implementation 'com.google.firebase:firebase-messaging:23.0.0'
}
```

2. Create `android/app/src/main/res/values/strings.xml`:
```xml
<resources>
    <string name="default_notification_channel_id">talent_sphere_channel</string>
    <string name="default_notification_channel_name">TalentSphere Notifications</string>
</resources>
```

### iOS

1. Enable Push Notifications in Xcode
2. Add to `ios/Runner/AppDelegate.swift`:
```swift
import Firebase
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    UNUserNotificationCenter.current().delegate = self
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## 🚀 Running the Application

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Run the App

```bash
# For development
flutter run

# For production
flutter run --release
```

### 3. Test Authentication

Use these test accounts:
- **Admin**: `admin@123` / `admin@123`
- **Client**: `owner` / any password
- **Regular User**: Create through sign-up

## 📊 Database Structure

### Collections Overview

```
users/
├── {userId}/
│   ├── email: string
│   ├── name: string
│   ├── role: enum (freelancer, client, admin)
│   ├── skills: array
│   ├── profileImageUrl: string
│   └── ... other fields

projects/
├── {projectId}/
│   ├── title: string
│   ├── description: string
│   ├── clientId: string
│   ├── freelancerId: string
│   ├── status: enum
│   ├── budget: number
│   └── ... other fields

teams/
├── {teamId}/
│   ├── name: string
│   ├── leaderId: string
│   ├── members: array
│   └── ... other fields

payments/
├── {paymentId}/
│   ├── projectId: string
│   ├── fromUserId: string
│   ├── toUserId: string
│   ├── amount: number
│   ├── status: enum
│   └── ... other fields

notifications/
├── {notificationId}/
│   ├── userId: string
│   ├── title: string
│   ├── body: string
│   ├── type: enum
│   └── ... other fields
```

## 🔧 Environment Variables

Create a `.env` file in the root directory:

```env
STRIPE_PUBLISHABLE_KEY=pk_test_your_key_here
STRIPE_SECRET_KEY=sk_test_your_key_here
FIREBASE_PROJECT_ID=talentsphere-app
```

## 🧪 Testing

### Unit Tests

```bash
flutter test
```

### Integration Tests

```bash
flutter test integration_test/
```

## 📈 Monitoring

### Firebase Analytics

1. Enable Analytics in Firebase Console
2. View user behavior and app performance
3. Set up custom events for key actions

### Crashlytics

1. Enable Crashlytics in Firebase Console
2. Monitor app crashes and errors
3. Get detailed crash reports

## 🚀 Deployment

### Android

1. Build APK:
```bash
flutter build apk --release
```

2. Build App Bundle:
```bash
flutter build appbundle --release
```

### iOS

1. Build for iOS:
```bash
flutter build ios --release
```

2. Archive in Xcode for App Store submission

### Web

1. Build for web:
```bash
flutter build web --release
```

2. Deploy to Firebase Hosting:
```bash
firebase deploy
```

## 🔒 Security Best Practices

1. **Firestore Rules**: Implement proper security rules
2. **API Keys**: Never commit API keys to version control
3. **Authentication**: Use Firebase Auth for all user operations
4. **Data Validation**: Validate all user inputs
5. **File Uploads**: Implement proper file type and size validation

## 🆘 Troubleshooting

### Common Issues

1. **Firebase not initialized**: Check `firebase_options.dart`
2. **Authentication fails**: Verify Firebase Auth configuration
3. **Storage upload fails**: Check Firebase Storage rules
4. **Push notifications not working**: Verify FCM setup

### Debug Mode

Enable debug logging:

```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable debug mode
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

## 📞 Support

For issues and questions:
1. Check Firebase Console for errors
2. Review Flutter logs: `flutter logs`
3. Test with Firebase Emulator Suite
4. Check network connectivity

## 🎯 Next Steps

1. Set up CI/CD pipeline
2. Implement advanced analytics
3. Add automated testing
4. Set up monitoring and alerting
5. Implement backup strategies

---

**Note**: This setup provides a production-ready backend for TalentSphere. Make sure to configure all services properly and test thoroughly before deploying to production.
