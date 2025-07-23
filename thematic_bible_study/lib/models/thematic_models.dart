// lib/models/thematic_models.dart

class VerseReference {
  final String formattedReference;
  final String bookName;
  final int chapterNumber;
  final int? verseNumber; // Make nullable, for single verses
  final int? verseStart;  // New: for verse ranges
  final int? verseEnd;    // New: for verse ranges

  VerseReference({
    required this.formattedReference,
    required this.bookName,
    required this.chapterNumber,
    this.verseNumber, // Not required if using start/end
    this.verseStart,  // Not required if using single verseNumber
    this.verseEnd,    // Not required if using single verseNumber
  }) : assert(
          (verseNumber != null && verseStart == null && verseEnd == null) || // Case 1: Single verse
          (verseNumber == null && verseStart != null && verseEnd != null), // Case 2: Verse range
          'A VerseReference must have either a single verseNumber OR both verseStart and verseEnd, but not both or neither.',
        );

  factory VerseReference.fromJson(Map<String, dynamic> json) {
    return VerseReference(
      formattedReference: json['formattedReference'] as String,
      bookName: json['bookName'] as String,
      chapterNumber: json['chapterNumber'] as int,
      verseNumber: json['verseNumber'] as int?, // Crucial: Safely read as nullable int
      verseStart: json['verseStart'] as int?,   // Crucial: Safely read as nullable int
      verseEnd: json['verseEnd'] as int?,       // Crucial: Safely read as nullable int
    );
  }
}

class BibleTheme {
  final String name;
  final String description;
  final List<VerseReference> verses;

  BibleTheme({
    required this.name,
    required this.description,
    required this.verses,
  });

  factory BibleTheme.fromJson(Map<String, dynamic> json) {
    var versesList = json['verses'] as List;
    List<VerseReference> parsedVerses = versesList
        .map((i) => VerseReference.fromJson(i as Map<String, dynamic>))
        .toList();

    return BibleTheme(
      name: json['name'] as String,
      description: json['description'] as String,
      verses: parsedVerses,
    );
  }
}