import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Initialize Firebase
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  // Add data to a Firestore collection
  Future<void> addData(String collection, Map<String, dynamic> data) async {
    try {
      await _db.collection(collection).add(data);
    } catch (e) {
      print('Error adding data: $e');
      rethrow; // Re-throw the exception for handling in the UI
    }
  }

  // Get all documents from a Firestore collection
  Stream<QuerySnapshot> getCollection(String collection) {
    return _db.collection(collection).snapshots();
  }

  // Get a specific document from a Firestore collection by ID
  Future<DocumentSnapshot> getDocumentById(String collection, String documentId) async {
    try {
      return await _db.collection(collection).doc(documentId).get();
    } catch (e) {
      print('Error getting document: $e');
      rethrow;
    }
  }

  // Update a specific document in a Firestore collection by ID
  Future<void> updateDocument(String collection, String documentId, Map<String, dynamic> data) async {
    try {
      await _db.collection(collection).doc(documentId).update(data);
    } catch (e) {
      print('Error updating document: $e');
      rethrow;
    }
  }

  // Delete a specific document from a Firestore collection by ID
  Future<void> deleteDocument(String collection, String documentId) async {
    try {
      await _db.collection(collection).doc(documentId).delete();
    } catch (e) {
      print('Error deleting document: $e');
      rethrow;
    }
  }
}