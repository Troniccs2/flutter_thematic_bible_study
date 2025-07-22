// lib/screens/bible_reader_screen.dart
import 'package:flutter/material.dart';
import 'package:thematic_bible_study/models/bible_models.dart';
import 'package:thematic_bible_study/services/bible_data_service.dart';

class BibleReaderScreen extends StatefulWidget {
  const BibleReaderScreen({super.key});

  @override
  State<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends State<BibleReaderScreen> {
  final BibleDataService _bibleDataService = BibleDataService();

  List<String> _bookNames = [];
  String? _selectedBookName;
  int _selectedChapterNumber = 1;

  Future<Book>? _loadedBookFuture;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final names = await _bibleDataService.loadBookNames();
      setState(() {
        _bookNames = names;
        _selectedBookName = _bookNames.isNotEmpty ? 'Genesis' : null;
      });
      _loadSelectedBookAndChapter();
    } catch (e) {
      print('Error loading initial data: $e');
    }
  }

  void _loadSelectedBookAndChapter() {
    if (_selectedBookName != null) {
      setState(() {
        _loadedBookFuture = _bibleDataService.loadBook(_selectedBookName!);
      });
    }
  }

  // --- NEW METHODS FOR NAVIGATION ---
  void _goToPreviousChapter(int totalChapters) {
    if (_selectedChapterNumber > 1) {
      setState(() {
        _selectedChapterNumber--;
      });
    }
  }

  void _goToNextChapter(int totalChapters) {
    if (_selectedChapterNumber < totalChapters) {
      setState(() {
        _selectedChapterNumber++;
      });
    }
  }
  // --- END NEW METHODS ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible Reader'),
        // AppBar color is now defined in ThemeData in main.dart for consistency
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBookName,
                hint: const Text('Select Book', style: TextStyle(color: Colors.white)),
                dropdownColor: Theme.of(context).primaryColor,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedBookName = newValue;
                      _selectedChapterNumber = 1; // Reset chapter to 1 when book changes
                    });
                    _loadSelectedBookAndChapter();
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
              final Chapter? currentChapter = book.chapters.length >= _selectedChapterNumber
                  ? book.chapters[_selectedChapterNumber - 1]
                  : null;

              if (currentChapter == null) {
                 return const Center(child: Text('Chapter not found.'));
              }

              final int totalChapters = book.chapters.length; // Get total chapters for this book

              return Column(
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
                          }
                        },
                        items: List.generate(totalChapters, (index) => index + 1)
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: currentChapter.verses.map((verse) {
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
                  // --- NEW: Navigation Buttons ---
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _selectedChapterNumber > 1
                              ? () => _goToPreviousChapter(totalChapters)
                              : null, // Disable if on chapter 1
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Previous Chapter'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _selectedChapterNumber < totalChapters
                              ? () => _goToNextChapter(totalChapters)
                              : null, // Disable if on last chapter
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Next Chapter'),
                        ),
                      ],
                    ),
                  ),
                  // --- END NEW ---
                ],
              );
            } else {
              return const Center(child: Text('Book loaded but no chapters found.'));
            }
          } else {
            return const Center(child: Text('Select a book...'));
          }
        },
      ),
    );
  }
}