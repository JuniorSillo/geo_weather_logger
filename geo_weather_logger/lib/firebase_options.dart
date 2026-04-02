import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }


  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_WITH_REAL_API_KEY',
    appId: '1:91468610213:android:e0d479c467be9773732b4c',
    messagingSenderId: '000000000000',
    projectId: 'replace-with-your-project-id',
    storageBucket: 'replace.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_REAL_API_KEY',
    appId: '1:91468610213:ios:f8f5b0da5501f9f5732b4c',
    messagingSenderId: '000000000000',
    projectId: 'replace-with-your-project-id',
    iosBundleId: 'com.example.geoWeatherLogger',
    storageBucket: 'replace.firebasestorage.app',
  );
}
