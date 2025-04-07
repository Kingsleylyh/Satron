import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:satron/features/schedule/schedule_home.dart';
import 'package:satron/features/map/map_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override

  State<HomePage> createState() => _HomePageState();
  
  /*Widget build(BuildContext context) {
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
  }*/
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("HomePage"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
// Nicholas
              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, "/login");
                },
                child: Container(
                  height: 45,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Sign out",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}