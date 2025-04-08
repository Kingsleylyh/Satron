import 'package:flutter/material.dart';
import 'package:satron/features/schedule/bus_schedule.dart';
import 'package:satron/features/schedule/train_schedule.dart';
import 'package:satron/features/booking/booking_home.dart';
import 'package:satron/features/map/map_home.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Entry page for schedules (bus/ train)

/*class ScheduleHome extends StatelessWidget {
  const ScheduleHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF5E1DA),

      appBar: AppBar(
        title: const Text("Schedule Home"),
          backgroundColor: Color(0xFFE6B89C)
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

      )
    );
  }
}*/

/*class ScheduleHome extends StatelessWidget {
  const ScheduleHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E1DA),
      appBar: AppBar(
        title: const Text("Schedule Home"),
        backgroundColor: Color(0xFFE6B89C),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BusSchedule()));
                },
                child: Container(
                  width: 250,
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions_bus, color: Colors.brown),
                      SizedBox(width: 10),
                      Text("Bus Schedule", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TrainSchedule()));
                },
                child: Container(
                  width: 250,
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.train, color: Colors.brown),
                      SizedBox(width: 10),
                      Text("Train Schedule", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

/*// Bottom Navigation Bar
class ScheduleHome extends StatelessWidget {
  const ScheduleHome({super.key});

  void _navigateToPage(BuildContext context, int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BusSchedule()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TrainSchedule()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E1DA),
      appBar: AppBar(
        title: const Text("Schedule Home"),
        backgroundColor: Color(0xFFE6B89C),
      ),
      body: Center(child: Text("Select a Schedule", style: TextStyle(fontSize: 20))),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFE6B89C),
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey[700],
        onTap: (index) => _navigateToPage(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.directions_bus), label: "Bus"),
          BottomNavigationBarItem(icon: Icon(Icons.train), label: "Train"),
        ],
      ),
    );
  }
}*/

class ScheduleHome extends StatelessWidget {
  const ScheduleHome({super.key});

  void _navigateToPage(BuildContext context, int index) {
    if (index == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => BookingPage()));
    } else if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E1DA),
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: const Color(0xFFE6B89C),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context,  '/login');
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 搜索框
              TextField(
                decoration: InputDecoration(
                  labelText: "Search for bus station or train station",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              SizedBox(height: 20),

              // 标题
              Text("Schedule Options", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              SizedBox(height: 10),

              // Bus Schedule Card
              Card(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BusSchedule()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(Icons.directions_bus, color: Colors.brown),
                      title: Text("Bus Schedule"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Train Schedule Card
              Card(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TrainSchedule()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(Icons.train, color: Colors.brown),
                      title: Text("Train Schedule"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // 底部导航栏
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFE6B89C),
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey[700],
        onTap: (index) => _navigateToPage(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Booking"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
        ],
      ),
    );
  }
}




