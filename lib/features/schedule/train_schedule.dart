import 'package:flutter/material.dart';

// Train timetable screen
class TrainSchedule extends StatelessWidget {
  const TrainSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF5E1DA),

        appBar: AppBar(
            title: const Text("Train Schedule"),
            backgroundColor: Color(0xFFE6B89C)
        ),

    );
  }
}