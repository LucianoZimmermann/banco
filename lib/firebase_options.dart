// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBItFHHRlWiQOWWvOuy72JOS3yKbDdOXeI',
    appId: '1:899667271741:web:1373b8a3d81bc7a9fd8a54',
    messagingSenderId: '899667271741',
    projectId: 'n2flutter-a99af',
    authDomain: 'n2flutter-a99af.firebaseapp.com',
    storageBucket: 'n2flutter-a99af.firebasestorage.app',
    measurementId: 'G-T4B345CQC3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBY5szi4DnsS07OlwZVVOXNo6K4ar7c8Ms',
    appId: '1:899667271741:android:375ff9a8b940dd3bfd8a54',
    messagingSenderId: '899667271741',
    projectId: 'n2flutter-a99af',
    storageBucket: 'n2flutter-a99af.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyClvl6CvomSli-X3UOHAQtyV643H3Xswl4',
    appId: '1:899667271741:ios:5deb9730b0f18fd3fd8a54',
    messagingSenderId: '899667271741',
    projectId: 'n2flutter-a99af',
    storageBucket: 'n2flutter-a99af.firebasestorage.app',
    iosBundleId: 'com.example.android',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyClvl6CvomSli-X3UOHAQtyV643H3Xswl4',
    appId: '1:899667271741:ios:5deb9730b0f18fd3fd8a54',
    messagingSenderId: '899667271741',
    projectId: 'n2flutter-a99af',
    storageBucket: 'n2flutter-a99af.firebasestorage.app',
    iosBundleId: 'com.example.android',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBItFHHRlWiQOWWvOuy72JOS3yKbDdOXeI',
    appId: '1:899667271741:web:663cdecce7155e2dfd8a54',
    messagingSenderId: '899667271741',
    projectId: 'n2flutter-a99af',
    authDomain: 'n2flutter-a99af.firebaseapp.com',
    storageBucket: 'n2flutter-a99af.firebasestorage.app',
    measurementId: 'G-7ZHWW9V98S',
  );

}