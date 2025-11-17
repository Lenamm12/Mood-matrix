import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/entry.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _entriesController = StreamController<List<Entry>>.broadcast();
  StreamSubscription? _firestoreSubscription;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Stream<List<Entry>> get entriesStream => _entriesController.stream;

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
        notes TEXT,
        tags TEXT
      )
    ''');
  }

  static DatabaseHelper get instance => _instance;

  Future<List<Entry>> getEntries() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('entries', orderBy: 'date DESC');
    final entries = List.generate(maps.length, (i) {
      return Entry.fromMap(maps[i]);
    });
    if (!_entriesController.isClosed) {
      _entriesController.add(entries);
    }
    return entries;
  }

  Future<void> insertEntry(Entry entry) async {
    final db = await instance.database;
    await db.insert(
      'entries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await getEntries(); 
  }

  Future<void> deleteEntry(String id) async {
    final db = await instance.database;
    await db.delete('entries', where: 'id = ?', whereArgs: [id]);
    await getEntries(); 
  }

  Future<void> syncFromFirestore(User user) async {
    if (_firestoreSubscription != null) {
      await _firestoreSubscription!.cancel();
      _firestoreSubscription = null;
    }

    final collection = _firestore.collection('users').doc(user.uid).collection('entries');

    _firestoreSubscription = collection.snapshots().listen((snapshot) async {
      final db = await instance.database;
      final batch = db.batch();

      for (var change in snapshot.docChanges) {
        final entry = Entry.fromFirestore(change.doc);
        if (change.type == DocumentChangeType.removed) {
          batch.delete('entries', where: 'id = ?', whereArgs: [entry.id]);
        } else { 
          batch.insert(
            'entries',
            entry.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
      await batch.commit(noResult: true);
      await getEntries(); 
    }, onError: (error) {
        print("Firestore listener error: $error");
    });
  }


  Future<void> syncToFirestore(User user) async {
    final entries = await getEntries();
    final collection = _firestore.collection('users').doc(user.uid).collection('entries');
    for (var entry in entries) {
      await collection.doc(entry.id).set(entry.toMap());
    }
  }

  void dispose() {
    _firestoreSubscription?.cancel();
    _entriesController.close();
  }
}
