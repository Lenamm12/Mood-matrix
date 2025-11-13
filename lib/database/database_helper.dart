import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/entry.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'carelog_app.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS entries (
        id TEXT PRIMARY KEY,
        date TEXT,
        mood TEXT,
        notes TEXT
      )
    ''');
  }

  static DatabaseHelper get instance => _instance;

  Future<List<Entry>> getEntries() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('entries', orderBy: 'date DESC');
    return List.generate(maps.length, (i) {
      return Entry.fromMap(maps[i]);
    });
  }

  Future<void> insertEntry(Entry entry) async {
    final db = await instance.database;
    await db.insert(
      'entries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
