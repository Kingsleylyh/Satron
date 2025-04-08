import 'package:flutter/material.dart';
import 'package:satron/features/schedule/bus_schedule.dart';
import 'package:satron/features/schedule/train_schedule.dart';
import 'package:satron/features/booking/booking_home.dart';
import 'package:satron/features/map/map_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:satron/pages/user_auth/profile.dart';

class ScheduleHome extends StatefulWidget {
  const ScheduleHome({super.key});

  @override
  State<ScheduleHome> createState() => _ScheduleHomeState();
}

class _ScheduleHomeState extends State<ScheduleHome> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _ScheduleHomeBody(),
    const BookingPage(),
    const MapPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E1DA),
      appBar: AppBar(
        title: const Text("SATRON"),
        backgroundColor: const Color(0xFFE6B89C),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFE6B89C),
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey[700],
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: "Schedule",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Booking",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class _ScheduleHomeBody extends StatelessWidget {
  const _ScheduleHomeBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: "Search for bus station or train station",
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Schedule Options",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BusSchedule()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Icon(Icons.directions_bus, color: Colors.brown),
                  title: Text("Bus Schedule"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrainSchedule()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
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




