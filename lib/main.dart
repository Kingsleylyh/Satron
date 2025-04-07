import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:satron/features/app/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:satron/pages/user_auth/login.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/map/map_home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file with error handling
  try {
    await dotenv.load(fileName: ".env");
    print(".env file loaded successfully");
  } catch (e) {
    print("Error loading .env file: $e");
  }

  // Initialize Firebase with error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization failed: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Flutter Application",
      home: SplashScreen(child: LoginPage()),
    );
  }
}



