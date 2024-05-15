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
    apiKey: 'AIzaSyDz_63izSl14z8i7AyrbqREKZzYLT9u2Pg',
    appId: '1:592643690621:web:77056bad1b60c1f2dda114',
    messagingSenderId: '592643690621',
    projectId: 'notes-b7337',
    authDomain: 'notes-b7337.firebaseapp.com',
    storageBucket: 'notes-b7337.appspot.com',
    measurementId: 'G-9BB0BEMX8J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAn370wi80LjqA9Gf6fIBP86IQZytpdlTM',
    appId: '1:592643690621:android:b15659adb93811d5dda114',
    messagingSenderId: '592643690621',
    projectId: 'notes-b7337',
    storageBucket: 'notes-b7337.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDPRG4e_BUztxoEN3r8P6Ynss5s8XkmUIg',
    appId: '1:592643690621:ios:dadd3b2f0a3ff0fddda114',
    messagingSenderId: '592643690621',
    projectId: 'notes-b7337',
    storageBucket: 'notes-b7337.appspot.com',
    iosBundleId: 'com.example.notes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDPRG4e_BUztxoEN3r8P6Ynss5s8XkmUIg',
    appId: '1:592643690621:ios:dadd3b2f0a3ff0fddda114',
    messagingSenderId: '592643690621',
    projectId: 'notes-b7337',
    storageBucket: 'notes-b7337.appspot.com',
    iosBundleId: 'com.example.notes',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDz_63izSl14z8i7AyrbqREKZzYLT9u2Pg',
    appId: '1:592643690621:web:a9aa1d21caa9d69fdda114',
    messagingSenderId: '592643690621',
    projectId: 'notes-b7337',
    authDomain: 'notes-b7337.firebaseapp.com',
    storageBucket: 'notes-b7337.appspot.com',
    measurementId: 'G-14JR3J0JMB',
  );

}