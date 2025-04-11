import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget _buildDeveloperTile({
    required String name,
    required String linkedInUrl,
    required String linkedInImagePath,
    required String email,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Row(
            children: [
              GestureDetector(
                onTap: () => _launchUrl(linkedInUrl),
                child: Row(
                  children: [
                    Image.asset(linkedInImagePath, width: 24, height: 24),
                    const SizedBox(width: 6),
                    const Text("LinkedIn", style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.email, color: Colors.red),
                onPressed: () => _launchUrl('mailto:$email'),
              ),
              GestureDetector(
                onTap: () => _launchUrl('mailto:$email'),
                child: Text(email, style: const TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact Us")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Developers", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildDeveloperTile(
              name: "Leong Yu Hang",
              linkedInUrl: "www.linkedin.com/in/yu-hang-leong-84b797321",
              linkedInImagePath: "assets/images/linkedin.png",
              email: "tp082419@mail.apu.edu.my",
            ),
            _buildDeveloperTile(
              name: "How Yong-Heng",
              linkedInUrl: "https://www.linkedin.com/in/yongheng-how-132776266/",
              linkedInImagePath: "assets/images/linkedin.png",
              email: "tp076463@mail.apu.edu.my",
            ),
            _buildDeveloperTile(
              name: "Nicholas Pang Tze Shen",
              linkedInUrl: "https://www.linkedin.com/in/nicholas-pang-tze-shen-8b7945272/",
              linkedInImagePath: "assets/images/linkedin.png",
              email: "tp076166@mail.apu.edu.my",
            ),
            _buildDeveloperTile(
              name: "Wang Liang Xuan",
              linkedInUrl: "https://linkedin.com",
              linkedInImagePath: "assets/images/linkedin.png",
              email: "tp076334@mail.apu.edu.my",
            ),
          ],
        ),
      ),
    );
  }
}
