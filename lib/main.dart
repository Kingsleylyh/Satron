import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:satron/pages/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options:
    FirebaseOptions(apiKey: ('${dotenv.env["FIREBASE_APIKEY"]}'),
        appId: ('${dotenv.env["FIREBASE_APPID"]}'),
        messagingSenderId: ('${dotenv.env["FIREBASE_MESSAGINGSENDERID"]}'),
        projectId: ('${dotenv.env["FIREBASE_PROJECTID"]}')));
  }

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage()
    );
  }
}
