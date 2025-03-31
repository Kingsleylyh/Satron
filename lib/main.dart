import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:satron/features/app/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:satron/pages/user_auth/login.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  if(kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Application",
      home: SplashScreen(child: LoginPage(),)
    );
  }
}

