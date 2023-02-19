import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_task/models/place.dart';

class FirestoreService {
  static Stream<List<Place>> getAllPlace() {
    return FirebaseFirestore.instance.collection('places').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => Place.fromJson(doc)).toList());
  }
}
