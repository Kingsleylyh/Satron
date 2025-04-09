import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:satron/pages/user_auth/login.dart';
import 'package:satron/pages/user_auth/update_profile.dart';
import 'package:satron/pages/user_auth/FAQs.dart';
import 'package:satron/features/booking/payment.dart';
import 'package:satron/features/booking/booking_history.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // Refresh the user data
  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
    });

    final currentUser = FirebaseAuth.instance.currentUser;
    await currentUser?.reload(); // Reload to ensure the user data is updated
    setState(() {
      user = FirebaseAuth.instance.currentUser;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE4E4E4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              children: [
                const SizedBox(width: 16),
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 30, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user!.displayName ?? "Username",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(user!.email ?? "No email"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildOptionButton(context, "Update My Profile", () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdateProfilePage(),
                ),
              );

              if (result == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                await _loadUser(); // Refresh after updating
              }
            }),

            _buildOptionButton(context, "Add a Payment Method", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaymentPage()),
              );
            }),

            _buildOptionButton(context, "Booking History", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookingHistoryPage()),
              );
            }),

            _buildOptionButton(context, "SATRON Website", () async {
              const url = 'https://github.com/Kingsleylyh/Satron';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not open website')),
                );
              }
            }),

            _buildOptionButton(context, "FAQs", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQPage()),
              );
            }),
            _buildOptionButton(context, "Livechat", () {}),
            _buildOptionButton(context, "Contact Us", () {}),
            _buildOptionButton(context, "Sign Out", () async {
              final shouldSignOut = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Confirm Sign Out"),
                  content: const Text("Are you sure you want to sign out?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        "Sign Out",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (shouldSignOut == true) {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false,
                );
              }
            }, isDanger: true),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String title, VoidCallback onTap,
      {bool isDanger = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: isDanger ? Colors.red[100] : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: isDanger ? Colors.red[900] : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
