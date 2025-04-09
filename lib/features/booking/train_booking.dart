import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrainBooking extends StatefulWidget {
  const TrainBooking({super.key});

  @override
  State<TrainBooking> createState() => _TrainBookingState();
}

class _TrainBookingState extends State<TrainBooking> {
  final _formKey = GlobalKey<FormState>();

  // Dummy train lines:
  final List<String> _trainLines = ["KLIA Express", "ETS", "KTM Komuter"];
  String? _selectedTrainLine;

  // Dummy station data (Stop 1 to Stop 10)
  List<String> _stations = [];
  String? _selectedStation;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    // Initially, do not populate stations until a line is selected.
    _stations = [];
  }

  /// Populate dummy station list with "Stop 1" until "Stop 10"
  void populateDummyStations() {
    setState(() {
      _stations = List.generate(10, (index) => 'Stop ${index + 1}');
      _selectedStation = null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      final String formattedDate =
      _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : '--';
      final String bookingInfo = '''
Train Line: $_selectedTrainLine
Station: $_selectedStation
Date: $formattedDate
Time: ${_selectedTime != null ? _selectedTime!.format(context) : '--'}
''';

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Train Booking Confirmed'),
          content: Text(bookingInfo),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close confirmation dialog
                Navigator.of(context).pop(); // Close booking page
              },
              child: const Text('OK'),
            ),
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
          color: Color(0xFFF1F8E9),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          controller: scrollController,
          children: [
            // Modal handle
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
            // Banner image
            Image.asset('assets/images/train.jpg', height: 180, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Train Line Dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Train Line',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedTrainLine,
                    items: _trainLines.map((line) {
                      return DropdownMenuItem(
                        value: line,
                        child: Text(line),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTrainLine = value;
                        if (value != null) {
                          populateDummyStations();
                        }
                      });
                    },
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please select a train line' : null,
                  ),
                  const SizedBox(height: 12),
                  // Station Dropdown, only enabled if a train line is selected.
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Station',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedStation,
                    items: _stations.map((station) {
                      return DropdownMenuItem(
                        value: station,
                        child: Text(station),
                      );
                    }).toList(),
                    onChanged: _selectedTrainLine == null
                        ? null
                        : (value) {
                      setState(() {
                        _selectedStation = value;
                      });
                    },
                    validator: (value) => _selectedTrainLine == null
                        ? null
                        : (value == null || value.isEmpty ? 'Please select a station' : null),
                  ),
                  const SizedBox(height: 12),
                  // Date and Time Picker UI
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'Select date'
                              : 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                        ),
                      ),
                      TextButton(
                        onPressed: () => _selectDate(context),
                        child: const Text('Pick Date'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedTime == null
                              ? 'Select time'
                              : 'Time: ${_selectedTime!.format(context)}',
                        ),
                      ),
                      TextButton(
                        onPressed: () => _selectTime(context),
                        child: const Text('Pick Time'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Submit Button
                  ElevatedButton(
                    onPressed: _submitBooking,
                    child: const Text('Book Train'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
