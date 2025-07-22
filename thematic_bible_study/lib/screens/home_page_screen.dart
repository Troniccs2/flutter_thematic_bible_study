// lib/screens/home_page_screen.dart
import 'package:flutter/material.dart';
import 'package:thematic_bible_study/services/bible_data_service.dart';
import 'package:thematic_bible_study/models/bible_models.dart';
import 'dart:math';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:shared_preferences/shared_preferences.dart'; // NEW: Import shared_preferences

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BibleDataService _bibleDataService = BibleDataService();
  Future<Verse?>? _verseOfTheDayFuture;

  // Keys for SharedPreferences
  static const String _lastVerseOfTheDayTimestampKey = 'lastVerseOfTheDayTimestamp';
  static const String _verseOfTheDayBookNameKey = 'verseOfTheDayBookName';
  static const String _verseOfTheDayChapterNumberKey = 'verseOfTheDayChapterNumber';
  static const String _verseOfTheDayVerseNumberKey = 'verseOfTheDayVerseNumber';
  static const String _verseOfTheDayTextKey = 'verseOfTheDayText';

  @override
  void initState() {
    super.initState();
    _loadVerseOfTheDay();
  }

  Future<void> _loadVerseOfTheDay() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? storedTimestampMillis = prefs.getInt(_lastVerseOfTheDayTimestampKey);

      Verse? verseToDisplay;

      // Check if a verse is already stored and if it's less than 24 hours old
      if (storedTimestampMillis != null) {
        final DateTime storedDateTime = DateTime.fromMillisecondsSinceEpoch(storedTimestampMillis);
        final Duration difference = DateTime.now().difference(storedDateTime);

        if (difference.inHours < 24) {
          // Verse is still fresh, load it from preferences
          final String? bookName = prefs.getString(_verseOfTheDayBookNameKey);
          final int? chapterNumber = prefs.getInt(_verseOfTheDayChapterNumberKey);
          final int? verseNumber = prefs.getInt(_verseOfTheDayVerseNumberKey);
          final String? text = prefs.getString(_verseOfTheDayTextKey);

          if (bookName != null && chapterNumber != null && verseNumber != null && text != null) {
            verseToDisplay = Verse(
              bookName: bookName,
              chapterNumber: chapterNumber,
              verseNumber: verseNumber,
              text: text,
            );
            debugPrint('Using stored Verse of the Day (less than 24 hours old).');
          }
        }
      }

      // If no fresh verse was found in preferences, generate a new one
      if (verseToDisplay == null) {
        debugPrint('Generating a new Verse of the Day.');
        final List<String> bookNames = await _bibleDataService.loadBookNames();
        if (bookNames.isEmpty) {
          setState(() {
            _verseOfTheDayFuture = Future.value(null);
          });
          return;
        }

        final Random random = Random();
        final String randomBookName = bookNames[random.nextInt(bookNames.length)];

        final Book randomBook = await _bibleDataService.loadBook(randomBookName);
        if (randomBook.chapters.isEmpty) {
          setState(() {
            _verseOfTheDayFuture = Future.value(null);
          });
          return;
        }

        final Chapter randomChapter = randomBook.chapters[random.nextInt(randomBook.chapters.length)];
        if (randomChapter.verses.isEmpty) {
          setState(() {
            _verseOfTheDayFuture = Future.value(null);
          });
          return;
        }

        final Verse selectedVerse = randomChapter.verses[random.nextInt(randomChapter.verses.length)];

        // Create the new Verse object with full reference for display and storage
        verseToDisplay = Verse(
          verseNumber: selectedVerse.verseNumber,
          text: selectedVerse.text,
          bookName: randomBook.name,
          chapterNumber: randomChapter.chapterNumber,
        );

        // Store the new verse details and the current timestamp
        await prefs.setInt(_lastVerseOfTheDayTimestampKey, DateTime.now().millisecondsSinceEpoch);
        await prefs.setString(_verseOfTheDayBookNameKey, verseToDisplay.bookName!);
        await prefs.setInt(_verseOfTheDayChapterNumberKey, verseToDisplay.chapterNumber!);
        await prefs.setInt(_verseOfTheDayVerseNumberKey, verseToDisplay.verseNumber);
        await prefs.setString(_verseOfTheDayTextKey, verseToDisplay.text);
      }

      setState(() {
        _verseOfTheDayFuture = Future.value(verseToDisplay);
      });
    } catch (e) {
      debugPrint('Error loading/generating Verse of the Day: $e');
      setState(() {
        _verseOfTheDayFuture = Future.error('Failed to load Verse of the Day');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome section
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withAlpha((255 * 0.1).round()),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.church,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Thematic Bible Study App',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Your daily companion for scripture exploration.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Verse of the Day Section
              Text(
                'Verse of the Day',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder<Verse?>(
                    future: _verseOfTheDayFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (snapshot.hasData && snapshot.data != null) {
                        final Verse verse = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              verse.text,
                              style: const TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                height: 1.5,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                // Use null-aware operators (?) or check for null if not absolutely sure
                                // that bookName and chapterNumber will always be non-null here.
                                // With the fix in _loadVerseOfTheDay, they should be present.
                                '${verse.bookName} ${verse.chapterNumber}:${verse.verseNumber}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Center(child: Text('No verse of the day available.'));
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Favorite Verse Section (Placeholder for now)
              Text(
                'Your Favorite Verse',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'This section will show your favorite verse!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Feature coming soon!')),
                          );
                          // TODO: Implement favorite verse storage and display
                        },
                        icon: const Icon(Icons.favorite_border),
                        label: const Text('Manage Favorites'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}