// lib/models/bible_models.dart

class Verse {
  final int verseNumber;
  final String text;

  Verse({required this.verseNumber, required this.text});

  // Factory constructor to create a Verse object from a JSON map
  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      // *** CHANGE HERE: Use int.parse() to convert the string 'verse' to an int ***
      verseNumber: int.parse(json['verse'].toString()),
      text: json['text'] as String,
    );
  }
}

class Chapter {
  final int chapterNumber;
  final List<Verse> verses;

  Chapter({required this.chapterNumber, required this.verses});

  // Factory constructor to create a Chapter object from a JSON map
  factory Chapter.fromJson(Map<String, dynamic> json) {
    var versesList = json['verses'] as List;
    List<Verse> chapterVerses =
        versesList.map((verseJson) => Verse.fromJson(verseJson)).toList();

    return Chapter(
      // *** CHANGE HERE: Use int.parse() to convert the string 'chapter' to an int ***
      chapterNumber: int.parse(json['chapter'].toString()),
      verses: chapterVerses,
    );
  }
}

// The Book class remains EXACTLY the same as it was, no changes needed for it.
class Book {
  final String name;
  final List<Chapter> chapters;

  Book({required this.name, required this.chapters});

  factory Book.fromJson(Map<String, dynamic> json) {
    var chaptersList = json['chapters'] as List;
    List<Chapter> bookChapters =
        chaptersList.map((chapterJson) => Chapter.fromJson(chapterJson)).toList();

    return Book(
      name: json['book'] as String,
      chapters: bookChapters,
    );
  }
}