import 'package:flutter/material.dart';

class FlightBooking extends StatefulWidget {
  const FlightBooking({super.key});

  @override
  State<FlightBooking> createState() => _FlightBookingState();
}

class _FlightBookingState extends State<FlightBooking> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _flightIdController = TextEditingController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      final info = '''
Flight ID: ${_flightIdController.text}
From: ${_originController.text}
To: ${_destinationController.text}
Date: ${_selectedDate?.toLocal().toString().split(' ')[0]}
Time: ${_selectedTime?.format(context)}
''';
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Flight Booking Confirmed'),
          content: Text(info),
          actions: [
            TextButton(
              onPressed: () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.95,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
          color: Color(0xFFE8F0F4),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          controller: scrollController,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Image.asset('assets/images/flight.jpg', height: 180, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  controller: _flightIdController,
                  decoration: const InputDecoration(labelText: 'Flight ID', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Enter Flight ID' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _originController,
                  decoration: const InputDecoration(labelText: 'Origin', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Enter origin' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _destinationController,
                  decoration: const InputDecoration(labelText: 'Destination', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Enter destination' : null,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: Text(_selectedDate == null ? 'Select date' : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}')),
                    TextButton(onPressed: () => _selectDate(context), child: const Text('Pick Date')),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Text(_selectedTime == null ? 'Select time' : 'Time: ${_selectedTime!.format(context)}')),
                    TextButton(onPressed: () => _selectTime(context), child: const Text('Pick Time')),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _submitBooking, child: const Text('Book Flight')),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
