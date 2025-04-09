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
      backgroundColor: const Color(0xFFE4E4E4), // 主背景色保持不变
      body: Column(
        children: [
          // --- 顶部标题栏（优化配色）---
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top  + 16,
              bottom: 16,
              left: 24,
              right: 24,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F8F8), // 调整为更柔和的浅灰
              boxShadow: [
                BoxShadow(
                  color: Color(0x0A000000), // 更 subtle 的阴影
                  blurRadius: 6,
                  offset: Offset(0, 1),
                ),
              ],
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFEAEAEA), // 增强层次感的细边框
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "SATRON",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF333333),
                    letterSpacing: 1.2,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context,  '/login');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFDDDDDD),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _pages[_currentIndex]),
        ],
      ),
      // --- 底部导航栏（优化配色）---
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFFE0E0E0), // 加深顶部边框
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFFF5F5F5), // 浅灰背景
          selectedItemColor: const Color(0xFF222222), // 深灰选中文字
          unselectedItemColor: const Color(0xFF777777), // 中灰未选中文字
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          elevation: 0,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            _buildNavItem(Icons.schedule_outlined,  Icons.schedule,  "Schedule", 0),
            _buildNavItem(Icons.book_outlined,  Icons.book,  "Booking", 1),
            _buildNavItem(Icons.map_outlined,  Icons.map,  "Map", 2),
            _buildNavItem(Icons.person_outline,  Icons.person,  "Profile", 3),
          ],
        ),
      ),
    );
  }

  // 封装导航项构建方法
  BottomNavigationBarItem _buildNavItem(
      IconData icon, IconData activeIcon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentIndex == index
              ? const Color(0xFFEAEAEA) // 选中态背景
              : Colors.transparent,
        ),
        child: Icon(icon),
      ),
      activeIcon: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFEAEAEA),
        ),
        child: Icon(activeIcon),
      ),
      label: label,
    );
  }
}

// --- 主页内容部分（保持不变）---
class _ScheduleHomeBody extends StatelessWidget {
  const _ScheduleHomeBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24,  24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 搜索框
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for bus or train station",
                hintStyle: const TextStyle(color: Color(0xFF999999)),
                prefixIcon: const Icon(Icons.search,  color: Color(0xFF999999)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical:  16),
              ),
            ),
          ),
          const SizedBox(height: 28),
          // 标题
          const Padding(
            padding: EdgeInsets.only(left:  4),
            child: Text(
              "Schedule Options",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF444444),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 选项卡片
          _buildScheduleOption(
            icon: Icons.directions_bus,
            title: "Bus Schedule",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BusSchedule()),
            ),
          ),
          const SizedBox(height: 12),
          _buildScheduleOption(
            icon: Icons.train,
            title: "Train Schedule",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TrainSchedule()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        splashColor: const Color(0xFFF0F0F0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFEEEEEE),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF999999),
              ),
            ],
          ),
        ),
      ),
    );
  }
}