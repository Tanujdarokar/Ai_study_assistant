import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF4F46E5);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("About App", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: accentColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // App Logo / Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.school_outlined, size: 80, color: accentColor),
            ),
            const SizedBox(height: 20),
            const Text(
              "AI Study Assist",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "AI Study Assist is an intelligent learning companion designed to help students master complex subjects using the power of Generative AI. Our mission is to make education personalized, accessible, and engaging for everyone.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF475569)),
              ),
            ),
            const SizedBox(height: 40),
            _buildFeatureRow(Icons.check_circle_outline, "Personalized AI Explanations"),
            _buildFeatureRow(Icons.check_circle_outline, "Smart Summarization Tools"),
            _buildFeatureRow(Icons.check_circle_outline, "Interactive Mock Quizzes"),
            const SizedBox(height: 50),
            const Text("Made with ❤️ for Students", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 15),
          Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
