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

  List<String> _bookNames = [];
  List<int> _chapterNumbers = [];

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final Map<int, Note?> _notesCache = {};

  @override
  void initState() {
    super.initState();
    _selectedBookName = widget.initialBookName;
    _selectedChapterNumber = widget.initialChapterNumber;
    _initializeBibleData();
  }

  Future<void> _initializeBibleData() async {
    try {
      final List<String> allBookNames = await _bibleDataService.loadBookNames();
      if (!mounted) return;
      _bookNames = allBookNames;

      await _loadSelectedBookAndChapter();

      if (!mounted) return;
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
      if (!mounted) return;
      setState(() {
        _selectedBook = book;
        _chapterNumbers = List.generate(book.chapters.length, (index) => index + 1);
        if (_selectedChapterNumber > book.chapters.length) {
          _selectedChapterNumber = 1;
        }
      });
      await _loadNotesForCurrentChapter();
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

      _notesCache.clear();
      for (var note in notes) {
        _notesCache[note.verseNumber] = note;
      }
      if (!mounted) return;
      setState(() {});
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
        _notesCache.clear();
      });
      _loadNotesForCurrentChapter();
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
                  controller: noteController,
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
                Navigator.of(context).pop();
              },
            ),
            if (existingNote != null)
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
                onPressed: () async {
                  if (existingNote.id != null) {
                    await _dbHelper.deleteNote(existingNote.id!);
                    debugPrint('Note deleted for $currentBookName $currentChapterNumber:${verse.verseNumber}');
                  }
                  if (!mounted) return;
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
                      existingNote.noteText = noteText;
                      await _dbHelper.updateNote(existingNote);
                      debugPrint('Note updated for $currentBookName $currentChapterNumber:${verse.verseNumber}');
                    } else {
                      final newNote = Note(
                        bookId: bookId,
                        chapterNumber: currentChapterNumber,
                        verseNumber: verse.verseNumber,
                        noteText: noteText,
                      );
                      final int newId = await _dbHelper.insertNote(newNote);
                      debugPrint('Note inserted with ID: $newId for $currentBookName $currentChapterNumber:${verse.verseNumber}');
                    }
                  } catch (e) {
                    debugPrint('Error saving note: $e');
                  }
                } else {
                  if (existingNote != null && existingNote.id != null) {
                    await _dbHelper.deleteNote(existingNote.id!);
                    debugPrint('Note implicitly deleted (empty text) for $currentBookName $currentChapterNumber:${verse.verseNumber}');
                  }
                }
                if (!mounted) return;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
        final bool hasNote = verseNote != null && verseNote.noteText.isNotEmpty;

        return GestureDetector(
          onTap: () async {
            await _showNoteDialog(verse);
            await _loadNotesForCurrentChapter();
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
                if (hasNote)
                  Padding(
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
        title: const Text('Bible Reader'),
      ),
      body: _selectedBook == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildVerseListView(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
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
                                child: Text(value, overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      Flexible(
                        flex: 1,
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

                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: _selectedChapterNumber > 1 ? _goToPreviousChapter : null,
                      ),

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