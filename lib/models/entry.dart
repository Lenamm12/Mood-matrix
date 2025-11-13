import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Entry {
  late final String id;
  late final String date;
  late final String mood;
  late final String? notes;

  Entry({String? id, required this.date, required this.mood, this.notes})
    : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {'id': id, 'date': date, 'mood': mood, 'notes': notes};
  }

  static Entry fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Entry(
      id: doc.id,
      date: data['date'],
      mood: data['mood'],
      notes: data['notes'],
    );
  }
}
