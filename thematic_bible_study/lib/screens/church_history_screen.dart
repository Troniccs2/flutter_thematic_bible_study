import 'package:flutter/material.dart';
import 'package:thematic_bible_study/screens/solas_screen.dart'; // <--- NEW: Import the SolasScreen

class ChurchHistoryScreen extends StatelessWidget {
  const ChurchHistoryScreen({super.key});

  // Data for each of the history cards
  // Added a 'destination' key to identify where each card should navigate
  final List<Map<String, dynamic>> _cardData = const [
    {
      'title': 'The Solas',
      'subtitle': 'Core Beliefs',
      'icon': Icons.article_outlined,
      'destination': 'solas', // This will map to SolasScreen
    },
    {
      'title': 'Timeline',
      'subtitle': 'A Chronological Look',
      'icon': Icons.access_time,
      'destination': 'timeline', // Placeholder for future navigation
    },
    {
      'title': 'Key Figures',
      'subtitle': 'Influential Leaders',
      'icon': Icons.person,
      'destination': 'key_figures', // Placeholder
    },
    {
      'title': 'Major Events',
      'subtitle': 'Defining Moments',
      'icon': Icons.flag,
      'destination': 'major_events', // Placeholder
    },
    {
      'title': 'Primary Docs',
      'subtitle': 'Original Writings',
      'icon': Icons.book,
      'destination': 'primary_docs', // Placeholder
    },
    {
      'title': 'Glossary',
      'subtitle': 'Key Terms Explained',
      'icon': Icons.translate,
      'destination': 'glossary', // Placeholder
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Church History'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Header Section ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CHURCH HISTORY',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'The Story of Faith & Reform',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- Grid of Cards Section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.9,
                ),
                itemCount: _cardData.length,
                itemBuilder: (context, index) {
                  final card = _cardData[index];
                  return _buildHistoryCard(
                    context,
                    card['title']!,
                    card['subtitle']!,
                    card['icon']!,
                    card['destination']!, // <--- Pass the new 'destination' parameter
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper method to build each history card
  // Modified to accept a 'destination' parameter for navigation logic
  Widget _buildHistoryCard(BuildContext context, String title, String subtitle, IconData icon, String destination) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // --- NEW NAVIGATION LOGIC ---
          if (destination == 'solas') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SolasScreen()),
            );
          } else {
            // For other cards, keep the placeholder snackbar for now
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You tapped on: $title - This section is under construction!')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}