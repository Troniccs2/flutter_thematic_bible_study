// lib/screens/sola_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:thematic_bible_study/models/sola.dart';

class SolaDetailScreen extends StatelessWidget {
  final Sola sola;

  const SolaDetailScreen({super.key, required this.sola});

  String? _getBackgroundImage(String solaTitle) {
    switch (solaTitle) {
      case 'Sola Scriptura':
        return 'assets/images/sola_Scriptura.png';
      case 'Sola Fide':
        return 'assets/images/sola_Fide.png';
      case 'Sola Gratia':
        return 'assets/images/sola_Gratia.png';
      case 'Solus Christus':
        return 'assets/images/sola_Christus.png';
      case 'Soli Deo Gloria':
        return 'assets/images/sola_Deo_Gloria.png';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? backgroundImagePath = _getBackgroundImage(sola.title);
    final bool hasCustomBackground = backgroundImagePath != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(sola.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          if (hasCustomBackground)
            Positioned.fill(
              child: Opacity(
                opacity: 0.15,
                child: Image.asset(
                  backgroundImagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sola.subtitle,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 20.0),

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
                    color: Colors.blue.shade50.withOpacity(hasCustomBackground ? 0.8 : 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Text(
                    sola.meaning,
                    style: const TextStyle(fontSize: 16.0, height: 1.5),
                  ),
                ),
                const SizedBox(height: 30.0),

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
                    color: Colors.green.shade50.withOpacity(hasCustomBackground ? 0.8 : 1.0),
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
                const SizedBox(height: 30.0),

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
                    color: Colors.purple.shade50.withOpacity(hasCustomBackground ? 0.8 : 1.0),
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
                              '“${quote['text']}”',
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
                                  '- ${quote['author']}',
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
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}