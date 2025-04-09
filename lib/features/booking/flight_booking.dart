import 'package:flutter/material.dart';

class FlightBooking extends StatelessWidget {
  const FlightBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFE8F0F4),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // Banner image (optional)
            Image.asset(
              'assets/images/flight.jpg',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),
            // Coming Soon Icon
            Center(
              child: Icon(
                Icons.flight_outlined,
                size: 64,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            // Coming Soon Text
            Center(
              child: Text(
                "Coming Soon",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Description Text
            Center(
              child: Text(
                "Booking flights will be available in future versions.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Additional spacing or any extra information can be placed here.
          ],
        ),
      ),
    );
  }
}
