import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDwZv61IbpcZBgSC4_LcX7lNg2Xp8Euo8o",
            authDomain: "pantryplus-27080.firebaseapp.com",
            projectId: "pantryplus-27080",
            storageBucket: "pantryplus-27080.appspot.com",
            messagingSenderId: "714769292366",
            appId: "1:714769292366:web:0f6df76472021da944771f",
            measurementId: "G-3GSZE5VRM2"));
  } else {
    await Firebase.initializeApp();
  }
}
