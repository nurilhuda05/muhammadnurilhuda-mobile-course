// File generated for Firebase configuration in Offline Notes (Jobsheet 14)
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBiVsg_2_Uo2Q6_2CFiqxrJhUhg9SkExBI',
    appId: '1:407445810200:android:1e1b6e0ee7a02a30ec276d',
    messagingSenderId: '407445810200',
    projectId: 'campusnotify-62201',
    storageBucket: 'campusnotify-62201.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBiVsg_2_Uo2Q6_2CFiqxrJhUhg9SkExBI',
    appId: '1:407445810200:ios:1e1b6e0ee7a02a30ec276d',
    messagingSenderId: '407445810200',
    projectId: 'campusnotify-62201',
    storageBucket: 'campusnotify-62201.firebasestorage.app',
    iosBundleId: 'com.example.week5_offline_notes',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBiVsg_2_Uo2Q6_2CFiqxrJhUhg9SkExBI',
    appId: '1:407445810200:web:1e1b6e0ee7a02a30ec276d',
    messagingSenderId: '407445810200',
    projectId: 'campusnotify-62201',
    storageBucket: 'campusnotify-62201.firebasestorage.app',
  );
}
