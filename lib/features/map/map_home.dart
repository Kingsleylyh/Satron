import 'package:flutter/material.dart';

// Map Page
class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        backgroundColor: Color(0xFFE6B89C),
      ),
      body: Center(
        child: Text("Map Page Content Here", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
