import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:satron/src/gtfs-realtime.pb.dart';
import 'package:intl/intl.dart';

class BusBooking extends StatefulWidget {
  const BusBooking({super.key});

  @override
  State<BusBooking> createState() => _BusBookingState();
}

class _BusBookingState extends State<BusBooking> {
  final _formKey = GlobalKey<FormState>();

  // Dynamic items fetched from API.
  List<String> _busLines = [];
  String? _selectedBusLine;

  List<String> _stations = [];
  String? _selectedStation;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    fetchBusLines();
  }

  /// Calls the GTFS realtime API and extracts unique bus lines (route IDs)
  Future<void> fetchBusLines() async {
    const url =
        'https://api.data.gov.my/gtfs-realtime/vehicle-position/prasarana?category=rapid-bus-kl';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final feed = FeedMessage.fromBuffer(response.bodyBytes);
        // Extract unique bus lines from the trip.routeId fields:
        final Set<String> routes = {};
        for (var entity in feed.entity) {
          if (entity.hasVehicle() &&
              entity.vehicle.trip.hasRouteId() &&
              entity.vehicle.trip.routeId.isNotEmpty) {
            routes.add(entity.vehicle.trip.routeId);
          }
        }
        setState(() {
          _busLines = routes.toList();
        });
      } else {
        debugPrint('Error fetching bus lines: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception fetching bus lines: $e');
    }
  }

  /// Populates dummy stations (Stop 1 to Stop 10) once a bus line is selected.
  void populateDummyStations() {
    setState(() {
      _stations = List.generate(10, (index) => 'Stop ${index + 1}');
      _selectedStation = null; // Reset selection
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
Bus Line: $_selectedBusLine
Station: $_selectedStation
Date: $formattedDate
Time: ${_selectedTime != null ? _selectedTime!.format(context) : '--'}
''';

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Booking Confirmed'),
          content: Text(bookingInfo),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
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
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE0F2F1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Modal handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  "Bus Booking",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              // Banner image
              Image.asset(
                'assets/images/bus.jpg',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              // Bus Line Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Bus Line',
                  border: OutlineInputBorder(),
                ),
                value: _selectedBusLine,
                items: _busLines.map((line) {
                  return DropdownMenuItem(
                    value: line,
                    child: Text(line),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBusLine = value;
                    // When a bus line is chosen, populate dummy stations.
                    if (value != null) {
                      populateDummyStations();
                    }
                  });
                },
                validator: (value) =>
                value == null || value.isEmpty ? 'Please select a bus line' : null,
              ),
              const SizedBox(height: 12),
              // Station Dropdown: Only enabled if a bus line is selected.
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
                onChanged: _selectedBusLine == null
                    ? null
                    : (value) {
                  setState(() {
                    _selectedStation = value;
                  });
                },
                validator: (value) => _selectedBusLine == null
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
                child: const Text('Book Now'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
