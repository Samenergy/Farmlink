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
    apiKey: 'AIzaSyCcjbOwCcO9xXY9SW9WOF451jnrKBfvyrg',
    appId: '1:626142691260:web:8815224f8f06788f1eb5b9',
    messagingSenderId: '626142691260',
    projectId: 'farmlink-8f61b',
    authDomain: 'farmlink-8f61b.firebaseapp.com',
    storageBucket: 'farmlink-8f61b.firebasestorage.app',
    measurementId: 'G-H60CBPZ292',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAXr5VAoFKJ4g6RUsxZgxKlUdMYgiQ-Sf4',
    appId: '1:626142691260:android:70bc7b9adb254f6d1eb5b9',
    messagingSenderId: '626142691260',
    projectId: 'farmlink-8f61b',
    storageBucket: 'farmlink-8f61b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAH4seRVt_ezKP_7vlgduJJpqgvw0hHHZg',
    appId: '1:626142691260:ios:cae18cfee1b8a59e1eb5b9',
    messagingSenderId: '626142691260',
    projectId: 'farmlink-8f61b',
    storageBucket: 'farmlink-8f61b.firebasestorage.app',
    iosBundleId: 'com.example.farmlink',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAH4seRVt_ezKP_7vlgduJJpqgvw0hHHZg',
    appId: '1:626142691260:ios:cae18cfee1b8a59e1eb5b9',
    messagingSenderId: '626142691260',
    projectId: 'farmlink-8f61b',
    storageBucket: 'farmlink-8f61b.firebasestorage.app',
    iosBundleId: 'com.example.farmlink',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCcjbOwCcO9xXY9SW9WOF451jnrKBfvyrg',
    appId: '1:626142691260:web:6dac54ae2a5138931eb5b9',
    messagingSenderId: '626142691260',
    projectId: 'farmlink-8f61b',
    authDomain: 'farmlink-8f61b.firebaseapp.com',
    storageBucket: 'farmlink-8f61b.firebasestorage.app',
    measurementId: 'G-SKDWK4J7MP',
  );
}
