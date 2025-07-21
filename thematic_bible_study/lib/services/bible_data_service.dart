// lib/services/bible_data_service.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/bible_models.dart';
import '../models/thematic_models.dart';

class BibleDataService {
  // Method to load a specific book by its name (e.g., 'Genesis', 'John')
  Future<Book> loadBook(String bookName) async {
    // --- CHANGE THIS LINE ---
    // Remove all spaces from the bookName to match the file name
    final String formattedBookName = bookName.replaceAll(' ', '');
    final String assetPath = 'assets/bible_data/$formattedBookName.json';
    // --- END CHANGE ---

    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return Book.fromJson(jsonMap);
    } catch (e) {
      print('Error loading or parsing $formattedBookName.json: $e'); // Use formatted name in error
      rethrow;
    }
  }

  Future<List<String>> loadBookNames() async {
    final String assetPath = 'assets/bible_data/Books.json';
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final dynamic decodedJson = jsonDecode(jsonString);

      if (decodedJson is List) {
        List<String> bookNames = [];
        for (var item in decodedJson) {
          if (item is String) {
            bookNames.add(item);
          } else {
            print('Warning: Found non-string item in Books.json: $item');
          }
        }
        return bookNames;
      } else {
        throw Exception("Books.json is not a direct list of strings.");
      }
    } catch (e) {
      print('Error loading book names from Books.json: $e');
      rethrow;
    }
  }

  Future<List<BibleTheme>> loadThemes() async {
    final String assetPath = 'assets/themes/thematic_data.json';
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final List<dynamic> jsonList = jsonDecode(jsonString);

      List<BibleTheme> themes =
          jsonList.map((json) => BibleTheme.fromJson(json as Map<String, dynamic>)).toList();
      return themes;
    } catch (e) {
      print('Error loading or parsing thematic_data.json: $e');
      rethrow;
    }
  }
}