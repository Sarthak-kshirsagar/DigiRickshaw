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
    apiKey: 'AIzaSyBwfsmUE92d4E0-yDXanRtQXH4xfF3IRDc',
    appId: '1:268860683923:web:88a993d99b4e39a725bf66',
    messagingSenderId: '268860683923',
    projectId: 'rickshaw2',
    authDomain: 'rickshaw2.firebaseapp.com',
    storageBucket: 'rickshaw2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAPV8cja4lrvSF9QFz2kpPqWmfZvoljkfM',
    appId: '1:268860683923:android:84ab34b5c05521d625bf66',
    messagingSenderId: '268860683923',
    projectId: 'rickshaw2',
    storageBucket: 'rickshaw2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB3PjlKg-1BvjwSn_kxezNex2hPWsVIahI',
    appId: '1:268860683923:ios:61e7aff79319a79025bf66',
    messagingSenderId: '268860683923',
    projectId: 'rickshaw2',
    storageBucket: 'rickshaw2.appspot.com',
    iosBundleId: 'com.example.rickshaw2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB3PjlKg-1BvjwSn_kxezNex2hPWsVIahI',
    appId: '1:268860683923:ios:b025a678f001c92b25bf66',
    messagingSenderId: '268860683923',
    projectId: 'rickshaw2',
    storageBucket: 'rickshaw2.appspot.com',
    iosBundleId: 'com.example.rickshaw2.RunnerTests',
  );
}