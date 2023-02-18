import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  final String name;
  final String city;
  final String imageUrl;
  Place({required this.name, required this.city, required this.imageUrl});

  factory Place.fromJson(DocumentSnapshot json) {
    return Place(
        name: json['name'], city: json['city'], imageUrl: json['imageUrl']);
  }
}
