import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions no están soportadas en esta plataforma.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAgR30Zd_4VT92dAJOcRA8n1sDAGQZEjY0',
    appId: '1:1016990153562:web:824106b9e1479027cb5163',
    messagingSenderId: '1016990153562',
    projectId: 'wilberts-store',
    authDomain: 'wilberts-store.firebaseapp.com',
    storageBucket: 'wilberts-store.appspot.com',
  );
}
