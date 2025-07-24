import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:thematic_bible_study/models/bible_models.dart';
import 'package:thematic_bible_study/models/thematic_models.dart';
import 'package:flutter/foundation.dart'; // Keep this import for debugPrint

class BibleDataService {
  final Map<String, Book> _bookCache = {};

  // Static list of all book names (as in your provided code)
  static const List<String> _allBookNames = [
    'Genesis', 'Exodus', 'Leviticus', 'Numbers', 'Deuteronomy',
    'Joshua', 'Judges', 'Ruth', '1 Samuel', '2 Samuel',
    '1 Kings', '2 Kings', '1 Chronicles', '2 Chronicles', 'Ezra',
    'Nehemiah', 'Esther', 'Job', 'Psalms', 'Proverbs',
    'Ecclesiastes', 'Song of Solomon', 'Isaiah', 'Jeremiah', 'Lamentations',
    'Ezekiel', 'Daniel', 'Hosea', 'Joel', 'Amos', 'Obadiah', 'Jonah',
    'Micah', 'Nahum', 'Habakkuk', 'Zephaniah', 'Haggai', 'Zechariah', 'Malachi',
    'Matthew', 'Mark', 'Luke', 'John', 'Acts', 'Romans',
    '1 Corinthians', '2 Corinthians', 'Galatians', 'Ephesians', 'Philippians',
    'Colossians', '1 Thessalonians', '2 Thessalonians', '1 Timothy', '2 Timothy',
    'Titus', 'Philemon', 'Hebrews', 'James', '1 Peter', '2 Peter',
    '1 John', '2 John', '3 John', 'Jude', 'Revelation'
  ];

  // NEW: Static map for book name to ID mapping
  // This map is generated once when the class is initialized
  static final Map<String, int> _bookNameToIdMap = _generateBookNameToIdMap();
  // NEW: Static map for book ID to name mapping
  static final Map<int, String> _bookIdToNameMap = _generateBookIdToNameMap();

  // NEW: Helper method to generate the book name to ID map
  static Map<String, int> _generateBookNameToIdMap() {
    final Map<String, int> map = {};
    for (int i = 0; i < _allBookNames.length; i++) {
      map[_allBookNames[i]] = i + 1; // Assign ID starting from 1
    }
    return map;
  }

  // NEW: Helper method to generate the book ID to name map
  static Map<int, String> _generateBookIdToNameMap() {
    final Map<int, String> map = {};
    for (int i = 0; i < _allBookNames.length; i++) {
      map[i + 1] = _allBookNames[i]; // Assign ID starting from 1
    }
    return map;
  }

  // NEW: Method to get book ID from book name
  int getBookIdFromName(String bookName) {
    final int? bookId = _bookNameToIdMap[bookName];
    if (bookId == null) {
      debugPrint('Warning: Book ID not found for book name: $bookName');
      throw Exception('Book ID not found for book name: $bookName');
    }
    return bookId;
  }

  // NEW: Method to get book name from book ID
  String getBookNameFromId(int bookId) {
    final String? bookName = _bookIdToNameMap[bookId];
    if (bookName == null) {
      debugPrint('Warning: Book name not found for book ID: $bookId');
      throw Exception('Book name not found for book ID: $bookId');
    }
    return bookName;
  }

  // @override removed as it's not overriding any inherited method
  Future<List<String>> loadBookNames() async {
    try {
      debugPrint('Loaded book names successfully from static list.');
      return _allBookNames; // Return the static list directly
    } catch (e) {
      debugPrint('Error loading book names: $e');
      return [];
    }
  }

  Future<Book> loadBook(String bookName) async {
    if (_bookCache.containsKey(bookName)) {
      debugPrint('Loading book from cache: $bookName');
      return _bookCache[bookName]!;
    }

    try {
      final String formattedBookName = bookName.replaceAll(' ', '');
       debugPrint('DEBUG: Attempting to load book: "$bookName". Formatted as "$formattedBookName". Path will be "assets/bible_data/$formattedBookName.json"');
      final String path = 'assets/bible_data/$formattedBookName.json';

      final String jsonString = await rootBundle.loadString(path);
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      final Book book = Book.fromJson(jsonMap);
      _bookCache[bookName] = book;
      debugPrint('Loaded book: ${book.name} from assets successfully.');
    } catch (e) {
      // Fix for unnecessary_brace_in_string_interps
      debugPrint('Error loading or parsing $bookName.json: $e');
      rethrow;
    }
    return _bookCache[bookName]!; // Return the cached book after successful load
  }

  Future<List<BibleTheme>> loadThemes() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/themes/thematic_data.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<BibleTheme> themes = jsonList.map((json) => BibleTheme.fromJson(json as Map<String, dynamic>)).toList();
      debugPrint('Loaded ${themes.length} themes successfully.');
      return themes;
    } catch (e) {
      debugPrint('Error loading themes from assets: $e');
      return [];
    }
  }

  Future<String> getVerseText(VerseReference verseRef) async {
    try {
      final Book book = await loadBook(verseRef.bookName);

      final Chapter chapter = book.chapters.firstWhere(
        (c) => c.chapterNumber == verseRef.chapterNumber,
        orElse: () => throw Exception('Chapter ${verseRef.chapterNumber} not found in ${verseRef.bookName}'),
      );

      // Handle single verse
      if (verseRef.verseNumber != null) {
        final Verse verse = chapter.verses.firstWhere(
          (v) => v.verseNumber == verseRef.verseNumber,
          orElse: () => throw Exception('Verse ${verseRef.verseNumber} not found in ${verseRef.bookName} chapter ${verseRef.chapterNumber}'),
        );
        return verse.text;
      }
      // Handle verse range
      else if (verseRef.verseStart != null && verseRef.verseEnd != null) {
        if (verseRef.verseStart! > verseRef.verseEnd!) {
          throw Exception('Verse start cannot be greater than verse end for range: ${verseRef.formattedReference}');
        }

        final List<String> texts = [];
        for (int i = verseRef.verseStart!; i <= verseRef.verseEnd!; i++) {
          final Verse verse = chapter.verses.firstWhere(
            (v) => v.verseNumber == i,
            orElse: () => throw Exception('Verse $i not found in ${verseRef.bookName} chapter ${verseRef.chapterNumber} for range ${verseRef.formattedReference}'),
          );
          texts.add('${i}. ${verse.text}');
        }
        return texts.join('\n');
      } else {
        return 'Error: Invalid verse reference type.';
      }
    } catch (e) {
      debugPrint('Error getting verse text for ${verseRef.formattedReference}: $e');
      return 'Error: Could not load verse text for ${verseRef.formattedReference}. ($e)';
    }
  }
}