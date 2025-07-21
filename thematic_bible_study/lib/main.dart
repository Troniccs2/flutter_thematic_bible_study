// lib/main.dart
import 'package:flutter/material.dart';
import 'package:thematic_bible_study/models/bible_models.dart';
import 'package:thematic_bible_study/services/bible_data_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thematic Bible Study App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BibleReaderScreen(),
    );
  }
}

class BibleReaderScreen extends StatefulWidget {
  const BibleReaderScreen({super.key});

  @override
  State<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends State<BibleReaderScreen> {
  final BibleDataService _bibleDataService = BibleDataService();

  List<String> _bookNames = []; // To store all book names
  String? _selectedBookName;   // Currently selected book
  int _selectedChapterNumber = 1; // Currently selected chapter (default to 1)

  Future<Book>? _loadedBookFuture; // Future to hold our loaded book

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // Call a new method to load everything
  }

  Future<void> _loadInitialData() async {
    try {
      // Load all book names first
      final names = await _bibleDataService.loadBookNames();
      setState(() {
        _bookNames = names;
        // Set an initial selected book, e.g., 'Genesis' or the first one
        _selectedBookName = _bookNames.isNotEmpty ? 'Genesis' : null;
      });
      // Load the initial selected book
      _loadSelectedBookAndChapter();
    } catch (e) {
      print('Error loading initial data: $e');
      // Handle error for initial data loading (e.g., show a persistent error message)
    }
  }

  void _loadSelectedBookAndChapter() {
    if (_selectedBookName != null) {
      setState(() {
        // Assign the Future to _loadedBookFuture
        _loadedBookFuture = _bibleDataService.loadBook(_selectedBookName!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible Reader'), // General title
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          // Book Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonHideUnderline( // Hides the default underline
              child: DropdownButton<String>(
                value: _selectedBookName,
                hint: const Text('Select Book', style: TextStyle(color: Colors.white)),
                dropdownColor: Theme.of(context).primaryColor, // Dropdown background color
                style: const TextStyle(color: Colors.white, fontSize: 16), // Text style for items
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedBookName = newValue;
                      _selectedChapterNumber = 1; // Reset chapter to 1 when book changes
                    });
                    _loadSelectedBookAndChapter(); // Load the new book
                  }
                },
                items: _bookNames.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          // Chapter Selector (will be populated once a book is loaded)
          // For simplicity, we'll put this inside the FutureBuilder's hasData block later.
          // Or, we can keep it here and enable/disable based on _loadedBookFuture state.
          // Let's integrate it more smartly in the body for now.
        ],
      ),
      body: FutureBuilder<Book>(
        future: _loadedBookFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading Bible data: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final Book book = snapshot.data!;
            if (book.chapters.isNotEmpty) {
              // Get the selected chapter. Ensure _selectedChapterNumber is valid.
              final Chapter? currentChapter = book.chapters.length >= _selectedChapterNumber
                  ? book.chapters[_selectedChapterNumber - 1]
                  : null; // Use null if chapter is out of bounds (shouldn't happen with proper logic)

              if (currentChapter == null) {
                 return const Center(child: Text('Chapter not found.'));
              }

              return Column( // Use Column to stack chapter selector and text box
                children: [
                  // Chapter Selector
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _selectedChapterNumber,
                        hint: const Text('Select Chapter'),
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedChapterNumber = newValue;
                            });
                            // No need to reload book, just update UI with new chapter
                          }
                        },
                        items: List.generate(book.chapters.length, (index) => index + 1)
                            .map<DropdownMenuItem<int>>((int chapterNum) {
                          return DropdownMenuItem<int>(
                            value: chapterNum,
                            child: Text('Chapter $chapterNum'),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  // The main Bible text box (expanded to fill remaining space)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Padding from screen edges
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: currentChapter.verses.map((verse) { // Use currentChapter.verses
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${verse.verseNumber}. ',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      TextSpan(
                                        text: verse.text,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          height: 1.5,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('Book loaded but no chapters found.'));
            }
          } else {
            return const Center(child: Text('Select a book...')); // Initial state before selection
          }
        },
      ),
    );
  }
}