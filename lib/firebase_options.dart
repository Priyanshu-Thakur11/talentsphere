// File simplified for Android-only Firebase configuration.
// ignore_for_file: type=lint

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase app.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are only configured for Android. '
          'To add other platforms, run the FlutterFire CLI again.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAd3kNhp9cxNPWf999FpQq4kizmYixNorA',
    appId: '1:1084083937441:android:e2d5ed525cd312d89bd0e0',
    messagingSenderId: '1084083937441',
    projectId: 'project1-b2ff8',
    storageBucket: 'project1-b2ff8.firebasestorage.app',
  );
}
