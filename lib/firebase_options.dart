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
    apiKey: 'AIzaSyCLsyTKQD_ZQBSydVu2iJqgJLi2YA3NOSQ',
    appId: '1:278754128602:web:6a835d69c3b4739001abe3',
    messagingSenderId: '278754128602',
    projectId: 'diabeater-77bc9',
    authDomain: 'diabeater-77bc9.firebaseapp.com',
    storageBucket: 'diabeater-77bc9.appspot.com',
    measurementId: 'G-730NL0XX2K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBVSf-vBpigmh3CyseGP1waCRLMGokowgU',
    appId: '1:278754128602:android:8b53271831f6e5df01abe3',
    messagingSenderId: '278754128602',
    projectId: 'diabeater-77bc9',
    storageBucket: 'diabeater-77bc9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBumVxRyvw3kZbIeIas_OlExzdjPxBUxfU',
    appId: '1:278754128602:ios:0e6be7bffcced57001abe3',
    messagingSenderId: '278754128602',
    projectId: 'diabeater-77bc9',
    storageBucket: 'diabeater-77bc9.appspot.com',
    iosClientId:
        '278754128602-cu3gajio3kt8ie4gjba6n0f72h8v41m2.apps.googleusercontent.com',
    iosBundleId: 'il.ac.technion.cs.diabeater.diabeater',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBumVxRyvw3kZbIeIas_OlExzdjPxBUxfU',
    appId: '1:278754128602:ios:0e6be7bffcced57001abe3',
    messagingSenderId: '278754128602',
    projectId: 'diabeater-77bc9',
    storageBucket: 'diabeater-77bc9.appspot.com',
    iosClientId:
        '278754128602-cu3gajio3kt8ie4gjba6n0f72h8v41m2.apps.googleusercontent.com',
    iosBundleId: 'il.ac.technion.cs.diabeater.diabeater',
  );
}
