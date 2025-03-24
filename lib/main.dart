import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uex_app/app_widget.dart';
import 'package:uex_app/config/routes/routes.dart';
import 'package:uex_app/core/firebase/firebase.dart';

import 'firebase_options.dart';

late final SharedPreferences preferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setPreferences();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, name: "UEX");

  final firebaseService = AuthService();
  firebaseService.authStateChanges.listen((User? user) {
    router;
  });
  runApp(AppWidget(preferences: preferences));
}

Future<void> setPreferences() async {
  preferences = await SharedPreferences.getInstance();
}
