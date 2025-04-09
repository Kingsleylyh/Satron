import 'package:flutter/material.dart';
import 'bus_booking.dart';
import 'train_booking.dart';
import 'flight_booking.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  void _openBottomSheet(BuildContext context, Widget bookingPage) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => bookingPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4E4E4),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _BookingCard(
              label: 'Bus Ticket',
              imagePath: 'assets/images/bus.jpg',
              onTap: () => _openBottomSheet(context, const BusBooking()),
            ),
            _BookingCard(
              label: 'Train Ticket',
              imagePath: 'assets/images/train.jpg',
              onTap: () => _openBottomSheet(context, const TrainBooking()),
            ),
            _BookingCard(
              label: 'Flight Ticket',
              imagePath: 'assets/images/flight.jpg',
              onTap: () => _openBottomSheet(context, const FlightBooking()),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onTap;

  const _BookingCard({
    required this.label,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            )
          ],
        ),
      ),
    );
  }
}
