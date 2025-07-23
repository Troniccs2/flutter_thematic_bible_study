// lib/screens/thematic_study_screen.dart
import 'package:flutter/material.dart';
import 'package:thematic_bible_study/models/thematic_models.dart';
import 'package:thematic_bible_study/services/bible_data_service.dart';
import 'package:thematic_bible_study/screens/verse_list_screen.dart'; // Import the new screen

class ThematicStudyScreen extends StatefulWidget {
  const ThematicStudyScreen({super.key});

  @override
  State<ThematicStudyScreen> createState() => _ThematicStudyScreenState();
}

class _ThematicStudyScreenState extends State<ThematicStudyScreen> {
  final BibleDataService _bibleDataService = BibleDataService();
  Future<List<BibleTheme>>? _themesFuture;

  @override
  void initState() {
    super.initState();
    // Load the themes when the screen initializes
    _themesFuture = _bibleDataService.loadThemes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thematic Study'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder<List<BibleTheme>>(
        future: _themesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading themes: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final List<BibleTheme> themes = snapshot.data!;
            if (themes.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: themes.length,
                itemBuilder: (context, index) {
                  final BibleTheme theme = themes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell( // Makes the card tappable
                      onTap: () {
                        // Navigate to the VerseListScreen, passing the selected theme
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerseListScreen(theme: theme),
                          ),
                        );
                        // You can remove the SnackBar and print statements now if you like,
                        // as the navigation will handle the display.
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('Tapped on theme: ${theme.name} - ${theme.verses.length} verses')),
                        // );
                        // print('Verses for ${theme.name}:');
                        // for (var ref in theme.verses) {
                        //   print(' - ${ref.formattedReference}');
                        // }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              theme.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              theme.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              '${theme.verses.length} verses',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No themes found.'));
            }
          } else {
            return const Center(child: Text('Loading themes...'));
          }
        },
      ),
    );
  }
}