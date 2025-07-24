class Note {
  int? id; // Nullable for when the note hasn't been saved to the DB yet
  final int bookId;
  final int chapterNumber;
  final int verseNumber;
  String noteText;
  final DateTime createdAt;
  DateTime updatedAt;

  Note({
    this.id,
    required this.bookId,
    required this.chapterNumber,
    required this.verseNumber,
    required this.noteText,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert a Note object into a Map object. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'book_id': bookId,
      'chapter_number': chapterNumber,
      'verse_number': verseNumber,
      'note_text': noteText,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Convert a Map object into a Note object.
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int,
      bookId: map['book_id'] as int,
      chapterNumber: map['chapter_number'] as int,
      verseNumber: map['verse_number'] as int,
      noteText: map['note_text'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  // A helper method for updating a Note object immutably
  Note copyWith({
    int? id,
    int? bookId,
    int? chapterNumber,
    int? verseNumber,
    String? noteText,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      verseNumber: verseNumber ?? this.verseNumber,
      noteText: noteText ?? this.noteText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Note(id: $id, bookId: $bookId, chapterNumber: $chapterNumber, verseNumber: $verseNumber, noteText: $noteText, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}