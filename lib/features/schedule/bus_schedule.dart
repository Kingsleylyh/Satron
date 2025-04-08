import 'package:flutter/material.dart';
import 'package:http/http.dart'  as http;
import 'package:satron/src/gtfs-realtime.pb.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart'  as geo;

class BusSchedule extends StatefulWidget {
  const BusSchedule({super.key});

  @override
  State<BusSchedule> createState() => _BusScheduleState();
}

class _BusScheduleState extends State<BusSchedule> {
  List<VehiclePosition> vehiclePositions = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  DateTime? lastUpdated;
  bool showMap = false;
  geo.Position? userPosition;
  Map<String, double> busDistances = {};
  http.Client? _httpClient; // 用于取消网络请求

  @override
  void initState() {
    super.initState();
    _httpClient = http.Client();
    _init();
  }

  @override
  void dispose() {
    _httpClient?.close(); // 取消所有pending的网络请求
    super.dispose();
  }

  Future<void> _init() async {
    await _getUserLocation();
    await fetchBusData();
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location service is not enabled.');

      geo.LocationPermission permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied)  {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied)  {
          throw Exception('Location permission denied.');
        }
      }

      final position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          userPosition = position;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          hasError = true;
          errorMessage = 'Failed to get location: $e';
        });
      }
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return geo.Geolocator.distanceBetween(lat1,  lon1, lat2, lon2);
  }

  Future<void> fetchBusData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      hasError = false;
    });

    const url = 'https://api.data.gov.my/gtfs-realtime/vehicle-position/prasarana?category=rapid-bus-kl';

    try {
      final response = await _httpClient!.get(Uri.parse(url));

      if (!mounted) return;

      if (response.statusCode  == 200) {
        final feed = FeedMessage.fromBuffer(response.bodyBytes);
        Map<String, double> distances = {};

        if (userPosition != null) {
          for (var entity in feed.entity)  {
            if (entity.hasVehicle())  {
              final vehicle = entity.vehicle;
              final distance = _calculateDistance(
                userPosition!.latitude,
                userPosition!.longitude,
                vehicle.position.latitude,
                vehicle.position.longitude,
              );
              distances[vehicle.vehicle.id] = distance;
            }
          }
        }

        if (mounted) {
          setState(() {
            vehiclePositions = feed.entity.where((e)  => e.hasVehicle()).map((e)  => e.vehicle).toList();
            busDistances = distances;
            isLoading = false;
            lastUpdated = DateTime.now();
          });
        }
      } else {
        throw Exception('Request failed: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = 'Failed to retrieve data: $e';
        });
      }
    }
  }

  Widget _buildBusInfoCard(VehiclePosition vehicle) {
    final distance = busDistances[vehicle.vehicle.id];
    final distanceText = distance != null ? '${distance.toStringAsFixed(0)}  meters' : "Calculating...";
    final eta = distance != null ? '${(distance / (30000 / 3600)).toStringAsFixed(0)} seconds' : '--';

    return Card(
      margin: const EdgeInsets.symmetric(vertical:  8, horizontal: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!,  width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.directions_bus,  color: Colors.grey[800]),
                ),
                const SizedBox(width: 12),
                Text(
                  'Bus ${vehicle.vehicle.id}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoItem(Icons.route,  vehicle.trip.routeId  ?? '--', 'Route'),
                const SizedBox(width: 16),
                _buildInfoItem(Icons.timer,  eta, 'ETA'),
                const SizedBox(width: 16),
                _buildInfoItem(Icons.place,  distanceText, 'Distance'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    LatLng center = const LatLng(3.1390, 101.6869);
    if (userPosition != null) {
      center = LatLng(userPosition!.latitude, userPosition!.longitude);
    }

    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        if (userPosition != null)
          MarkerLayer(
            markers: [
              Marker(
                width: 60,
                height: 60,
                point: LatLng(userPosition!.latitude, userPosition!.longitude),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Icon(Icons.person_pin_circle,  color: Colors.grey[800],  size: 40),
                ),
              ),
            ],
          ),
        MarkerLayer(
          markers: vehiclePositions.map((vehicle)  {
            return Marker(
              width: 50,
              height: 50,
              point: LatLng(vehicle.position.latitude,  vehicle.position.longitude),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Icon(Icons.directions_bus,  color: Colors.grey[800],  size: 30),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Bus Arrivals",
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.grey),
        actions: [
          IconButton(
            icon: Icon(showMap ? Icons.list  : Icons.map,  color: Colors.grey[800]),
            onPressed: () {
              if (mounted) {
                setState(() => showMap = !showMap);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh,  color: Colors.grey[800]),
            onPressed: fetchBusData,
          ),
        ],
      ),
      body: Column(
        children: [
          if (lastUpdated != null)
            Container(
              padding: const EdgeInsets.symmetric(vertical:  8),
              color: Colors.grey[100],
              child: Center(
                child: Text(
                  'Updated: ${lastUpdated!.toLocal().toString().substring(0, 19)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          if (userPosition != null)
            Container(
              padding: const EdgeInsets.symmetric(vertical:  8, horizontal: 16),
              color: Colors.grey[50],
              child: Row(
                children: [
                  Icon(Icons.location_on,  size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${userPosition!.latitude.toStringAsFixed(4)},  ${userPosition!.longitude.toStringAsFixed(4)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(
                color: Colors.grey[800],
              ),
            )
                : hasError
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: fetchBusData,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[800]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Retry',
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            )
                : vehiclePositions.isEmpty
                ? Center(
              child: Text(
                "No buses available",
                style: TextStyle(color: Colors.grey[800]),
              ),
            )
                : showMap
                ? _buildMapView()
                : RefreshIndicator(
              color: Colors.grey[800],
              onRefresh: fetchBusData,
              child: ListView.builder(
                itemCount: vehiclePositions.length,
                itemBuilder: (context, index) {
                  vehiclePositions.sort((a,  b) {
                    final distA = busDistances[a.vehicle.id] ?? double.infinity;
                    final distB = busDistances[b.vehicle.id] ?? double.infinity;
                    return distA.compareTo(distB);
                  });
                  return _buildBusInfoCard(vehiclePositions[index]);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchBusData,
        backgroundColor: Colors.white,
        elevation: 2,
        child: Icon(Icons.refresh,  color: Colors.grey[800]),
      ),
    );
  }
}

