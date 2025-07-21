// lib/models/thematic_models.dart

class VerseReference {
  final String book;
  final int chapter;
  final int verseStart;
  final int verseEnd; // Useful for verse ranges (e.g., 1 Cor 13:4-7)

  VerseReference({
    required this.book,
    required this.chapter,
    required this.verseStart,
    required this.verseEnd,
  });

  factory VerseReference.fromJson(Map<String, dynamic> json) {
    return VerseReference(
      book: json['book'] as String,
      chapter: json['chapter'] as int,
      verseStart: json['verseStart'] as int,
      verseEnd: json['verseEnd'] as int,
    );
  }

  // Helper method to format the reference for display
  String get formattedReference {
    if (verseStart == verseEnd) {
      return '$book $chapter:$verseStart';
    } else {
      return '$book $chapter:$verseStart-${verseEnd.toString().padLeft(2, '0')}'; // Pads single digit verses with '0'
    }
  }
}

class BibleTheme {
  final String name;
  final String description;
  final List<VerseReference> verses; // List of associated verse references

  BibleTheme({
    required this.name,
    required this.description,
    required this.verses,
  });

  factory BibleTheme.fromJson(Map<String, dynamic> json) {
    var versesList = json['verses'] as List;
    List<VerseReference> themeVerses =
        versesList.map((verseJson) => VerseReference.fromJson(verseJson)).toList();

    return BibleTheme(
      name: json['name'] as String,
      description: json['description'] as String,
      verses: themeVerses,
    );
  }
}