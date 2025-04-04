// Entry page for ticket bookings (bus/train)
import 'package:flutter/material.dart';

// Booking Page
class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking"),
        backgroundColor: Color(0xFFE6B89C),
      ),
      body: Center(
        child: Text("Booking Page Content Here", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}