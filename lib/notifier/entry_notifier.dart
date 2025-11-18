import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mood_matrix/database/database_helper.dart';
import 'package:mood_matrix/models/entry.dart';

class EntryNotifier with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Entry> _entries = [];

  List<Entry> get entries => _entries;

  EntryNotifier() {
    _dbHelper.entriesStream.listen((entries) {
      _entries = entries;
      notifyListeners();
    });
  }

  Future<void> loadEntries() async {
    await _dbHelper.getEntries();
  }

  Future<void> addEntry(Entry entry) async {
    await _dbHelper.insertEntry(entry);
  }

  void syncFromFirestore(User user) {
    _dbHelper.syncFromFirestore(user);
  }
}
