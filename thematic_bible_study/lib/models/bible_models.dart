// lib/models/bible_models.dart


class Verse {
  final int verseNumber;
  final String text;
  final String? bookName;
  final int? chapterNumber;

  Verse({
    required this.verseNumber,
    required this.text,
    this.bookName,
    this.chapterNumber,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      verseNumber: int.parse(json['verse'].toString()),
      text: json['text'] as String,
    );
  }

  String get formattedReference {
    if (bookName != null && chapterNumber != null) {
      return '$bookName $chapterNumber:$verseNumber';
    }
    return 'Verse $verseNumber';
  }
}

class Chapter {
  final int chapterNumber;
  final List<Verse> verses;

  Chapter({required this.chapterNumber, required this.verses});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    var versesList = json['verses'] as List;
    List<Verse> chapterVerses =
        versesList.map((verseJson) => Verse.fromJson(verseJson as Map<String, dynamic>)).toList();

    return Chapter(
      chapterNumber: int.parse(json['chapter'].toString()),
      verses: chapterVerses,
    );
  }
}

class Book {
  final String name;
  final List<Chapter> chapters;

  Book({required this.name, required this.chapters});

  factory Book.fromJson(Map<String, dynamic> json) {
    var chaptersList = json['chapters'] as List;
    List<Chapter> bookChapters =
        chaptersList.map((chapterJson) => Chapter.fromJson(chapterJson as Map<String, dynamic>)).toList();

    return Book(
      name: json['book'] as String,
      chapters: bookChapters,
    );
  }
}