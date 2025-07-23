// lib/services/bible_data_service.dart
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:thematic_bible_study/models/bible_models.dart';
import 'package:thematic_bible_study/models/thematic_models.dart';
import 'package:flutter/foundation.dart';

class BibleDataService {
  final Map<String, Book> _bookCache = {};

  Future<List<String>> loadBookNames() async {
    try {
      final List<String> bookNames = [
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
      debugPrint('Loaded book names successfully.');
      return bookNames;
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
      final String path = 'assets/bible_data/$formattedBookName.json';

      final String jsonString = await rootBundle.loadString(path);
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      final Book book = Book.fromJson(jsonMap);
      _bookCache[bookName] = book;
      debugPrint('Loaded book: ${book.name} from assets successfully.');
      return book;
    } catch (e) {
      debugPrint('Error loading or parsing ${bookName}.json: $e');
      rethrow;
    }
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
        // MODIFIED LINE: Changed '\n\n' to '\n'
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