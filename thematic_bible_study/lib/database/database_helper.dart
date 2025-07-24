// lib/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:thematic_bible_study/models/note.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static Database? _database;
  static final int _databaseVersion = 1; // You might need to increment this if you plan on proper migrations later

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'bible_notes.db');
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Ensure onUpgrade is defined if version increments
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // CRITICAL FIX: Add the 'book_id' column to the notes table
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        book_id INTEGER NOT NULL,  -- <<< ADD THIS LINE
        chapter_number INTEGER NOT NULL,
        verse_number INTEGER NOT NULL,
        note_text TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    // You might also need to create other tables if your app uses them
    // For example, if you have a 'books' table to map book names to IDs,
    // ensure that's also created here if not already.
    // For now, assuming only the 'notes' table is problematic.
    debugPrint('Database created successfully, including notes table with book_id.');
  }

  // Basic onUpgrade for simplicity. For production, you'd add ALTER TABLE statements.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('Upgrading database from version $oldVersion to $newVersion');
    // This is a simple upgrade strategy. For complex apps,
    // you'd write specific ALTER TABLE statements.
    // For now, if the schema changes, it's easier to just recreate for development.
    if (oldVersion < 2) {
      // Example: if you were going from version 1 to 2 and added a column
      // await db.execute("ALTER TABLE notes ADD COLUMN new_column TEXT;");
    }
  }


  // --- Note Operations ---

  Future<int> insertNote(Note note) async {
    final db = await database;
    // Map the Note object to a Map for database insertion
    final Map<String, dynamic> data = note.toMap();
    // Remove 'id' if it's null, so DB can auto-increment
    if (data['id'] == null) {
      data.remove('id');
    }
    return await db.insert(
      'notes',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> getNotesForChapter(int bookId, int chapterNumber) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'book_id = ? AND chapter_number = ?',
      whereArgs: [bookId, chapterNumber],
      orderBy: 'verse_number ASC',
    );
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Example method to get all notes (useful for debugging)
  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }
}