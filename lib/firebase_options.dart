// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBqwVUCVbLgKDBycCyT6TVZi89kGw4Gj6M',
    appId: '1:59549618023:web:c2261f5f5a91080d6a29c2',
    messagingSenderId: '59549618023',
    projectId: 'penmetch',
    authDomain: 'penmetch.firebaseapp.com',
    storageBucket: 'penmetch.appspot.com',
    measurementId: 'G-MBCMLFXK3N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB_zQMaPTCd3oZIMbgb-HDVaH13G0bzxv4',
    appId: '1:59549618023:android:cfe529e7f08837c96a29c2',
    messagingSenderId: '59549618023',
    projectId: 'penmetch',
    storageBucket: 'penmetch.appspot.com',
  );
}