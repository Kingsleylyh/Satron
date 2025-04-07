import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Map Page
class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OSM Flutter Map')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(3.0553, 101.6088), // Bukit Jalil coordinates
          initialZoom: 16.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.osm_flutter_demo',
          ),
        ],
      ),
    );
  }
}