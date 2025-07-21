// lib/services/bible_data_service.dart
import 'dart:convert'; // For jsonDecode
import 'package:flutter/services.dart' show rootBundle; // For loading assets
import '../models/bible_models.dart'; // Your custom models

class BibleDataService {
  // Method to load a specific book by its name (e.g., 'Genesis', 'John')
  Future<Book> loadBook(String bookName) async {
    // Construct the path to the JSON file
    final String assetPath = 'assets/bible_data/$bookName.json';

    try {
      // Load the JSON string from the asset bundle
      final String jsonString = await rootBundle.loadString(assetPath);

      // Decode the JSON string into a Dart map
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

      // Convert the JSON map into your Book object using the factory constructor
      return Book.fromJson(jsonMap);
    } catch (e) {
      // Handle errors (e.g., file not found, parsing error)
      print('Error loading or parsing $bookName.json: $e');
      rethrow; // Re-throw the error to be handled by the UI
    }
  }

  Future<List<String>> loadBookNames() async {
    final String assetPath = 'assets/bible_data/Books.json';
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final dynamic decodedJson = jsonDecode(jsonString); // Decode as dynamic

      if (decodedJson is List) {
        // If it's a list, we now expect it to be a list of strings directly
        List<String> bookNames = [];
        for (var item in decodedJson) {
          if (item is String) { // Check if the item is a String
            bookNames.add(item);
          } else {
            // Log if there's an unexpected type, but don't crash
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
}