import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildFaqItem(
            'How do I book a trip?',
            'Select a destination from the home screen, click "Book Now", choose your date and number of tickets, and confirm.',
          ),
          _buildFaqItem(
            'Where can I see my bookings?',
            'You can view all your confirmed trips in the "My Bookings" section of your profile.',
          ),
          _buildFaqItem(
            'How do I cancel a booking?',
            'Currently, cancellations are handled via our support email. Please contact support@wanderlust.com.',
          ),
          _buildFaqItem(
            'Is my payment secure?',
            'We use industry-standard encryption to ensure all your transaction data is safe and secure.',
          ),
          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 24),
          const Text(
            'Contact Us',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildContactInfo(Icons.email_outlined, 'support@wanderlust.com'),
          _buildContactInfo(Icons.phone_outlined, '+1 (555) 123-4567'),
          _buildContactInfo(Icons.location_on_outlined, '123 Travel Lane, Adventure City'),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F2C59)),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF0F2C59)),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
