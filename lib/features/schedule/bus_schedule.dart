import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:satron/src/gtfs-realtime.pb.dart';



// Bus timetable screen
class BusSchedule extends StatefulWidget {
  const BusSchedule({super.key});

  @override
  State<BusSchedule> createState() => _BusScheduleState();
}

class _BusScheduleState extends State<BusSchedule>{
  List<VehiclePosition> vehiclePositions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBusData();
  }

  Future<void> fetchBusData() async {
    const url = 'https://api.data.gov.my/gtfs-realtime/vehicle-position/prasarana?category=rapid-bus-kl';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200){
        final feed = FeedMessage.fromBuffer(response.bodyBytes);
        setState(() {
          vehiclePositions = feed.entity.where((e) => e.hasVehicle()).map((e) => e.vehicle).toList();
          isLoading = false;
        });
      }else{
        throw Exception('Failed to load GTFS data');
      }
    }catch (e){
      print('Error fetching GTFS: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E1DA),
      appBar: AppBar(
        title: const Text("Bus Schedule"),
        backgroundColor: const Color(0xFFE6B89C),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : vehiclePositions.isEmpty
          ? const Center(child: Text("No bus data found"))
          : ListView.builder(
        itemCount: vehiclePositions.length,
        itemBuilder: (context, index) {
          final vehicle = vehiclePositions[index];
          return ListTile(
            leading: const Icon(Icons.directions_bus),
            title: Text('Bus ID: ${vehicle.vehicle.id}'),
            subtitle: Text(
                'Lat: ${vehicle.position.latitude}, Lng: ${vehicle.position.longitude}'),
          );
        },
      ),
    );
  }
}
