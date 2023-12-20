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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyBvd9amk-iK4jq9IKVTqkoEjnS1wWMy1rc',
    appId: '1:1003695165998:web:42ea71a1640ea3e7e985bf',
    messagingSenderId: '1003695165998',
    projectId: 'fast-tracker-web',
    authDomain: 'fast-tracker-web.firebaseapp.com',
    storageBucket: 'fast-tracker-web.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDzsab2bERihej54qx25AN13mo41fNRIuA',
    appId: '1:1003695165998:android:a731ba66e9bce891e985bf',
    messagingSenderId: '1003695165998',
    projectId: 'fast-tracker-web',
    storageBucket: 'fast-tracker-web.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBzSC5Z9v1nCLlkCdtIufVruBXitEVtgAc',
    appId: '1:1003695165998:ios:7db9d54c0a59722de985bf',
    messagingSenderId: '1003695165998',
    projectId: 'fast-tracker-web',
    storageBucket: 'fast-tracker-web.appspot.com',
    iosBundleId: 'com.example.fasting',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBzSC5Z9v1nCLlkCdtIufVruBXitEVtgAc',
    appId: '1:1003695165998:ios:fc65e72ed4b4af6be985bf',
    messagingSenderId: '1003695165998',
    projectId: 'fast-tracker-web',
    storageBucket: 'fast-tracker-web.appspot.com',
    iosBundleId: 'com.example.fasting.RunnerTests',
  );
}