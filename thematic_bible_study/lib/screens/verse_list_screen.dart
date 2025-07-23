// lib/screens/verse_list_screen.dart
import 'package:flutter/material.dart';
import 'package:thematic_bible_study/models/thematic_models.dart';
import 'package:thematic_bible_study/services/bible_data_service.dart';

class VerseListScreen extends StatelessWidget {
  final BibleTheme theme;
  final BibleDataService _bibleDataService = BibleDataService();

  VerseListScreen({
    super.key,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${theme.name} Verses'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: theme.verses.isEmpty
            ? Center(child: Text('No verses found for ${theme.name}.'))
            : ListView.builder(
                itemCount: theme.verses.length,
                itemBuilder: (context, index) {
                  final VerseReference verseRef = theme.verses[index];

                  return FutureBuilder<String>(
                    future: _bibleDataService.getVerseText(verseRef),
                    builder: (context, snapshot) {
                      String verseTextContent = 'Loading verse...'; // Renamed variable for clarity
                      Color textColor = Colors.grey;

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Still loading
                      } else if (snapshot.hasError) {
                        verseTextContent = 'Error loading verse: ${snapshot.error}';
                        textColor = Colors.red;
                      } else if (snapshot.hasData) {
                        verseTextContent = snapshot.data!;
                        textColor = Colors.black87;
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column( // Use Column to arrange reference and text
                            crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start
                            children: [
                              Text(
                                verseRef.formattedReference, // Display the reference directly from verseRef
                                style: const TextStyle(
                                  fontSize: 18.0, // A bit bigger
                                  fontWeight: FontWeight.bold, // Bold
                                  color: Colors.deepPurple, // Optional: add a distinct color
                                ),
                              ),
                              const SizedBox(height: 8.0), // Spacing between reference and text
                              Text(
                                verseTextContent, // Display only the fetched text content
                                style: TextStyle(
                                  fontSize: 15.0, // Slightly smaller than reference, bigger than default
                                  color: textColor,
                                  height: 1.5, // Line height for better readability
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}