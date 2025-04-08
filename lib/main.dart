import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:satron/features/schedule/schedule_home.dart';
import 'package:satron/pages/user_auth/login.dart';
import 'package:satron/pages/user_auth/register.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:satron/features/app/splash_screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 环境变量加载
  await dotenv.load(fileName:  ".env");

  // Firebase 初始化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Satron App - 2025",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // 将SplashScreen设为首页，3秒后跳转到登录页
      home: SplashScreen(
        child: LoginPage(),
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/home': (context) => const ScheduleHome(),
      },
    );
  }
}

