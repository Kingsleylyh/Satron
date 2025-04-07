import 'package:flutter/material.dart';
import 'package:satron/features/schedule/schedule_home.dart';
import 'package:satron/features/map/map_home.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E1DA),

      appBar: AppBar(
          title: Text("Satron Application"),
          backgroundColor: Color(0xFFE6B89C),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 让内容垂直居中

        children: [
          Spacer(), // 占位，推上方内容
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 让按钮均匀排列

            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScheduleHome()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.schedule, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Schedule'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.directions_bus, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Booking'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapPage()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Map'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20), // 给按钮和底部留点空隙
        ],
      ),

    );
  }
}



