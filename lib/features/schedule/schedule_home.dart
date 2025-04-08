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

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScheduleHome extends StatelessWidget {
  const ScheduleHome({super.key});

  void _navigateToPage(BuildContext context, int index) {
    if (index == 0) {
      Navigator.push(context,  MaterialPageRoute(builder: (context) => BookingPage()));
    } else if (index == 1) {
      Navigator.push(context,  MaterialPageRoute(builder: (context) => MapPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 自定义标题栏
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:  16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SATRON",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[800],
                      letterSpacing: 1.2,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout,  color: Colors.grey[700]),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context,  '/login');
                    },
                  ),
                ],
              ),
            ),

            // 主体内容
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 搜索框
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Search for bus station or train station",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        prefixIcon: Icon(Icons.search,  color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: EdgeInsets.symmetric(vertical:  16),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 标题
                    Padding(
                      padding: const EdgeInsets.only(left:  8.0),
                      child: Text(
                        "Schedule Options",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Bus Schedule Card
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[200]!,  width: 1),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(context,  MaterialPageRoute(builder: (context) => BusSchedule()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListTile(
                            leading: Icon(Icons.directions_bus,  color: Colors.grey[700]),
                            title: Text(
                              "Bus Schedule",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios,  size: 16, color: Colors.grey[600]),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Train Schedule Card
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[200]!,  width: 1),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(context,  MaterialPageRoute(builder: (context) => TrainSchedule()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListTile(
                            leading: Icon(Icons.train,  color: Colors.grey[700]),
                            title: Text(
                              "Train Schedule",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios,  size: 16, color: Colors.grey[600]),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // 底部导航栏 (高级灰设计)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border(top: BorderSide(color: Colors.grey[200]!,  width: 1)),
        ),
        padding: EdgeInsets.only(bottom:  MediaQuery.of(context).padding.bottom),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.grey[800],
          unselectedItemColor: Colors.grey[500],
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
          type: BottomNavigationBarType.fixed,
          onTap: (index) => _navigateToPage(context, index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              activeIcon: Icon(Icons.book),
              label: "Booking",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map),
              label: "Map",
            ),
          ],
        ),
      ),
    );
  }
}




