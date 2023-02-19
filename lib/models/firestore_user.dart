import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserField {
  static const String lastCreationTime = 'lastCreationTime';
}

class FirestoreUser extends Equatable {
  final String idUser;
  final String email;
  final String? name;
  const FirestoreUser(
      {required this.idUser, required this.email, required this.name});

  static FirestoreUser fromJson(DocumentSnapshot snapshot) {
    FirestoreUser firestoreUser = FirestoreUser(
      idUser: snapshot['idUser'],
      email: snapshot['email'],
      name: snapshot['name'],
    );
    return firestoreUser;
  }

  Map<String, Object> toMap() {
    return {'idUser': idUser, 'email': email, 'name': name!};
  }

  @override
  List<Object> get props => [
        idUser,
        email,
      ];
}
