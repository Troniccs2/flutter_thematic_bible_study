// lib/screens/bible_reader_screen.dart
import 'package:flutter/material.dart';
import 'package:thematic_bible_study/services/bible_data_service.dart';
import 'package:thematic_bible_study/models/bible_models.dart';
import 'package:thematic_bible_study/database/database_helper.dart';
import 'package:thematic_bible_study/models/note.dart';

class BibleReaderScreen extends StatefulWidget {
  final String initialBookName;
  final int initialChapterNumber;

  const BibleReaderScreen({
    super.key,
    required this.initialBookName,
    required this.initialChapterNumber,
  });

  @override
  State<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends State<BibleReaderScreen> {
  final BibleDataService _bibleDataService = BibleDataService();
  Book? _selectedBook;
  String _selectedBookName = '';
  int _selectedChapterNumber = 1;

  List<String> _bookNames = []; // List of all book names for the dropdown
  List<int> _chapterNumbers = []; // List of chapter numbers for the currently selected book

  final DatabaseHelper _dbHelper = DatabaseHelper();
  // Using a Map<int, Note?> to store notes, where key is verseNumber
  final Map<int, Note?> _notesCache = {};

  @override
  void initState() {
    super.initState();
    _selectedBookName = widget.initialBookName;
    _selectedChapterNumber = widget.initialChapterNumber;
    _initializeBibleData(); // Load all books and then the selected one
  }

  Future<void> _initializeBibleData() async {
    try {
      final List<String> allBookNames = await _bibleDataService.loadBookNames();
      _bookNames = allBookNames;

      await _loadSelectedBookAndChapter();

      setState(() {
        if (_selectedBook != null) {
          _chapterNumbers = List.generate(_selectedBook!.chapters.length, (index) => index + 1);
        }
      });
    } catch (e) {
      debugPrint('Error initializing bible data: $e');
    }
  }

  Future<void> _loadSelectedBookAndChapter() async {
    try {
      final book = await _bibleDataService.loadBook(_selectedBookName);
      setState(() {
        _selectedBook = book;
        _chapterNumbers = List.generate(book.chapters.length, (index) => index + 1);
        if (_selectedChapterNumber > book.chapters.length) {
          _selectedChapterNumber = 1;
        }
      });
      await _loadNotesForCurrentChapter(); // Load notes after book/chapter is set
    } catch (e) {
      debugPrint('Error loading selected book and chapter: $e');
    }
  }

  Future<void> _loadNotesForCurrentChapter() async {
    if (_selectedBook == null) return;

    try {
      final int bookId = _bibleDataService.getBookIdFromName(_selectedBookName);
      final List<Note> notes = await _dbHelper.getNotesForChapter(
        bookId,
        _selectedChapterNumber,
      );

      _notesCache.clear(); // Clear old notes
      for (var note in notes) {
        _notesCache[note.verseNumber] = note; // Populate cache with notes from DB
      }
      setState(() {}); // Crucial: Rebuild UI to display note indicators
      debugPrint('Loaded ${notes.length} notes for $_selectedBookName $_selectedChapterNumber');
    } catch (e) {
      debugPrint('Error loading notes for chapter: $e');
    }
  }

  void _goToChapter(int chapterNumber) {
    if (_selectedBook != null &&
        chapterNumber >= 1 &&
        chapterNumber <= _selectedBook!.chapters.length) {
      setState(() {
        _selectedChapterNumber = chapterNumber;
        _notesCache.clear(); // Clear cache when changing chapter
      });
      _loadNotesForCurrentChapter(); // Load notes for the new chapter
    }
  }

  void _goToPreviousChapter() {
    _goToChapter(_selectedChapterNumber - 1);
  }

  void _goToNextChapter() {
    _goToChapter(_selectedChapterNumber + 1);
  }

  Future<void> _showNoteDialog(Verse verse) async {
    Note? existingNote = _notesCache[verse.verseNumber];
    // This controller is key: it's initialized with the existing note's text
    TextEditingController noteController =
        TextEditingController(text: existingNote?.noteText ?? '');

    String currentBookName = _selectedBookName;
    int currentChapterNumber = _selectedChapterNumber;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$currentBookName $currentChapterNumber:${verse.verseNumber}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${verse.verseNumber}. ${verse.text}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                const Divider(),
                const SizedBox(height: 8.0),
                TextField(
                  controller: noteController, // This text field *shows* the note content
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Enter your note here...',
                    border: OutlineInputBorder(),
                    labelText: 'Your Note',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
            if (existingNote != null) // Only show delete if a note already exists
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
                onPressed: () async {
                  if (existingNote.id != null) {
                    await _dbHelper.deleteNote(existingNote.id!);
                    debugPrint('Note deleted for $currentBookName $currentChapterNumber:${verse.verseNumber}');
                    // No need for _notesCache.remove and setState here,
                    // as _loadNotesForCurrentChapter will refresh everything
                  }
                  if (!mounted) return;
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                },
              ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                String noteText = noteController.text.trim();
                if (noteText.isNotEmpty) {
                  try {
                    final int bookId = _bibleDataService.getBookIdFromName(currentBookName);

                    if (existingNote != null) {
                      // Update existing note
                      existingNote.noteText = noteText;
                      await _dbHelper.updateNote(existingNote);
                      debugPrint('Note updated for $currentBookName $currentChapterNumber:${verse.verseNumber}');
                    } else {
                      // Insert new note
                      final newNote = Note(
                        bookId: bookId,
                        chapterNumber: currentChapterNumber,
                        verseNumber: verse.verseNumber,
                        noteText: noteText,
                      );
                      final int newId = await _dbHelper.insertNote(newNote);
                      debugPrint('Note inserted with ID: $newId for $currentBookName $currentChapterNumber:${verse.verseNumber}');
                    }
                    // No need for setState here, as _loadNotesForCurrentChapter will refresh everything
                  } catch (e) {
                    debugPrint('Error saving note: $e');
                  }
                } else {
                  // If note text is empty and there was an existing note, delete it
                  if (existingNote != null && existingNote.id != null) {
                    await _dbHelper.deleteNote(existingNote.id!);
                    debugPrint('Note implicitly deleted (empty text) for $currentBookName $currentChapterNumber:${verse.verseNumber}');
                    // No need for _notesCache.remove and setState here,
                    // as _loadNotesForCurrentChapter will refresh everything
                  }
                }
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Helper method to build just the ListView of verses
  Widget _buildVerseListView() {
    if (_selectedBook == null || _selectedBook!.chapters.isEmpty || _selectedChapterNumber < 1 || _selectedChapterNumber > _selectedBook!.chapters.length) {
      return const Center(child: Text('Chapter content not available.'));
    }

    final Chapter currentChapter =
        _selectedBook!.chapters[_selectedChapterNumber - 1];

    return ListView.builder(
      itemCount: currentChapter.verses.length,
      itemBuilder: (context, index) {
        final Verse verse = currentChapter.verses[index];
        final Note? verseNote = _notesCache[verse.verseNumber];
        // Assuming Note.noteText is a non-nullable String:
        final bool hasNote = verseNote != null && verseNote.noteText.isNotEmpty;

        // CRITICAL FIX: GestureDetector now wraps the entire Padding, making the whole verse row clickable.
        // It also AWAITS the dialog and then FORCES a reload of notes.
        return GestureDetector(
          onTap: () async { // Make the onTap async
            await _showNoteDialog(verse); // Await the dialog to close
            await _loadNotesForCurrentChapter(); // CRITICAL: Reload notes to ensure UI reflects changes
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 30.0,
                  child: Text(
                    '${verse.verseNumber}.',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                // Note icon is a visual indicator, displayed only if a note exists
                if (hasNote)
                  Padding( // Padding for spacing between verse number/icon and text
                    padding: const EdgeInsets.only(right: 4.0, left: 4.0),
                    child: Icon(
                      Icons.sticky_note_2_outlined,
                      size: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: verse.text,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible Reader'), // Simplified AppBar
      ),
      body: _selectedBook == null
          ? const Center(child: CircularProgressIndicator())
          : Column( // Main content of the screen
              children: [
                Expanded( // Bible text container takes up most of the space
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Padding around the Card
                    child: Card( // The Bible text content is now inside a Card
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding( // Internal padding for the ListView inside the Card
                        padding: const EdgeInsets.all(16.0),
                        child: _buildVerseListView(), // Call the helper method for the verses
                      ),
                    ),
                  ),
                ),
                // Controls section BELOW the Bible text container
                // Adjusted layout for better spacing and to fix potential pixel issues
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Adjusted padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space evenly
                    children: [
                      // Book Dropdown
                      Flexible( // Use Flexible for better control in rows
                        flex: 3, // Give more space to book name
                        child: DropdownButtonHideUnderline( // Hide default underline
                          child: DropdownButton<String>(
                            isExpanded: true, // Allow dropdown to expand
                            value: _selectedBookName,
                            onChanged: (String? newValue) async {
                              if (newValue != null) {
                                setState(() {
                                  _selectedBookName = newValue;
                                  _selectedChapterNumber = 1;
                                  _notesCache.clear();
                                });
                                await _loadSelectedBookAndChapter();
                              }
                            },
                            items: _bookNames.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, overflow: TextOverflow.ellipsis), // Handle long book names
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Chapter Dropdown
                      Flexible(
                        flex: 1, // Less space for chapter number
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            isExpanded: true,
                            value: _selectedChapterNumber,
                            onChanged: (int? newValue) {
                              if (newValue != null) {
                                _goToChapter(newValue);
                              }
                            },
                            items: _chapterNumbers.map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text('$value'),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Previous Chapter Button
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: _selectedChapterNumber > 1 ? _goToPreviousChapter : null,
                      ),

                      // Next Chapter Button
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: _selectedBook == null || _selectedChapterNumber >= _selectedBook!.chapters.length
                            ? null
                            : _goToNextChapter,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}