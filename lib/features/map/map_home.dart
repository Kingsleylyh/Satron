import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:satron/service/gemini_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GeminiService _gemini = GeminiService(apiKey: 'AIzaSyD_lLQPoGgTl6BCevB3bvsJWPxIron1bFs');
  final TextEditingController _destinationController = TextEditingController();
  LatLng? _currentPosition;
  String? _suggestedRoute;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _searchDestination() async {
    if (_currentPosition == null || _destinationController.text.isEmpty) return;

    final origin = "${_currentPosition!.latitude},${_currentPosition!.longitude}";
    final destination = _destinationController.text;

    final result = await _gemini.getRouteSuggestions(origin, destination);
    setState(() {
      _suggestedRoute = result ?? 'No suggestion found';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: _currentPosition ?? LatLng(3.0553, 101.6088),
            initialZoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.myapp',
            ),
            if (_currentPosition != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentPosition!,
                    width: 80,
                    height: 80,
                    child: const Icon(Icons.my_location, color: Colors.blue),
                  ),
                ],
              ),
          ],
        ),
        Positioned(
          top: 50,
          left: 15,
          right: 15,
          child: Card(
            elevation: 4,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _destinationController,
                    decoration: const InputDecoration(
                      hintText: 'Enter destination',
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchDestination,
                )
              ],
            ),
          ),
        ),
        if (_suggestedRoute != null)
          Positioned(
            bottom: 20,
            left: 15,
            right: 15,
            child: Card(
              color: Colors.white.withOpacity(0.95),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_suggestedRoute!),
              ),
            ),
          )
      ]),
    );
  }
}
