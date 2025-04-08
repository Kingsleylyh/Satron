import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:satron/features/schedule/schedule_home.dart';
import 'package:satron/pages/user_auth/login.dart';
import 'package:satron/pages/user_auth/register.dart';
import 'package:satron/features/app/splash_screen/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:satron/features/booking/booking_home.dart';
import 'package:satron/features/booking/bus_booking.dart';
import 'package:satron/features/booking/train_booking.dart';
import 'package:satron/features/booking/flight_booking.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
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
      // Splash screen as entry point
      home: const SplashScreen(
        child: LoginPage(),
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/home': (context) => const ScheduleHome(),
        '/booking': (context) => const BookingPage(),
        '/busBooking': (context) => const BusBooking(),
        '/trainBooking': (context) => const TrainBooking(),
        '/flightBooking': (context) => const FlightBooking(),
      },
    );
  }
}
