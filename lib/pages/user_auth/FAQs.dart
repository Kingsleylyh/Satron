import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Frequently Asked Questions"),
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFAQCard("What is SATRON?", "SATRON is a centralized platform that makes better convenience for Malaysians and tourists when it comes to travelling. No matter if it is driving or accessing public transport. With SATRON, GPS, traffic jam area alerts, booking transportation, public transport schedules, all in one app. Tourists never find it difficult again for inaccurate or outdated public transport information or directions."),
              const SizedBox(height: 16),
              _buildFAQCard("How does SATRON works?", "SATRON integrates APIs from government entities and various service providers into a single application, streamlining the process for users seeking directions. Unlike traditional GPS or booking apps, SATRON offers a comprehensive solution that encompasses multiple services in one platform. Additionally, SATRON aims to collaborate with government bodies to address traffic congestion and promote public transportation usage, aligning with governmental goals and policies while contributing to Sustainable Development Goal (SDG) 9 Industry, Innovation, and Infrastructure."),
              const SizedBox(height: 16),
              _buildFAQCard("Why is it named SATRON?", "Since it is a map specialized for Malaysia, we thought of the word 'Satu' which means 'one' to indicate one centralized app while also symbolises the united one Malaysia. The app also aims to provide swift and convenience service to the users, and we come up the idea of using 'Electron' as the symbol of swift and seamless user experience. Finally, we combine both the two terms and got the name SATRON."),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQCard(String question, String answer) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              answer,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
