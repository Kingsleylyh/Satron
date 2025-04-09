import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:satron/pages/user_auth/login.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Center(
        child: user == null
            ? const Text("No user logged in")
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.brown,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                user.email ?? "No email",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "UID: ${user.uid}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
