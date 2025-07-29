// lib/screens/sola_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:thematic_bible_study/models/sola.dart';

class SolaDetailScreen extends StatelessWidget {
  final Sola sola;

  const SolaDetailScreen({super.key, required this.sola});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sola.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sola Subtitle
            Text(
              sola.subtitle,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20.0),

            // Meaning Section
            Text(
              'Meaning:',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Text(
                sola.meaning,
                style: const TextStyle(fontSize: 16.0, height: 1.5),
              ),
            ),
            const SizedBox(height: 30.0),

            // Scripture Support Section
            Text(
              'Scripture to Support This:',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sola.scriptures.map((scripture) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      '• $scripture',
                      style: const TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 30.0), // Increased space for new section

            // --- NEW: Quotes Section ---
            Text(
              'Supporting Quotes:',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.purple.shade50, // Light purple background for quotes
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.purple.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sola.quotes.map((quote) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '“${quote['text']}”', // Quote text
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontStyle: FontStyle.italic,
                            color: Colors.black87,
                          ),
                        ),
                        if (quote['author'] != null && quote['author']!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                            child: Text(
                              '- ${quote['author']}', // Author
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20.0), // Space at the very bottom
          ],
        ),
      ),
    );
  }
}